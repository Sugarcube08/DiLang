import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../native_bridge.dart';
import 'installed_models_provider.dart';

enum ModelPipelineStage {
  idle,
  downloading,
  downloaded,
  verifying,
  installing,
  installed,
  failed,
}

class ModelDownloadState {
  final String? downloadingModelId;
  final String downloadingModelName;
  final double progress;
  final double verificationProgress;
  final double bytesDownloaded;
  final double totalBytes;
  final double bytesPerSec;
  final int etaSeconds;
  final String statusText;
  final String speedEtaText;
  final String stageLabel;
  final String stageStepText;
  final String shaProgressText;
  final bool isDownloading;
  final bool isVerifying;
  final ModelPipelineStage stage;
  final String? completedModelId;
  final String? error;
  final Map<String, ModelDownloadState> perModelProgress;

  ModelDownloadState({
    this.downloadingModelId,
    this.downloadingModelName = '',
    this.progress = 0.0,
    this.verificationProgress = 0.0,
    this.bytesDownloaded = 0.0,
    this.totalBytes = 0.0,
    this.bytesPerSec = 0.0,
    this.etaSeconds = 0,
    this.statusText = '',
    this.speedEtaText = '',
    this.stageLabel = '',
    this.stageStepText = '',
    this.shaProgressText = '',
    this.isDownloading = false,
    this.isVerifying = false,
    this.stage = ModelPipelineStage.idle,
    this.completedModelId,
    this.error,
    this.perModelProgress = const {},
  });

  bool get isDownloaded => stage.index >= ModelPipelineStage.downloaded.index && stage != ModelPipelineStage.failed;
  bool get isVerified => stage.index >= ModelPipelineStage.installing.index && stage != ModelPipelineStage.failed;
  bool get isInstalled => stage == ModelPipelineStage.installed;

  ModelDownloadState copyWith({
    Object? downloadingModelId = _sentinel,
    String? downloadingModelName,
    double? progress,
    double? verificationProgress,
    double? bytesDownloaded,
    double? totalBytes,
    double? bytesPerSec,
    int? etaSeconds,
    String? statusText,
    String? speedEtaText,
    String? stageLabel,
    String? stageStepText,
    String? shaProgressText,
    bool? isDownloading,
    bool? isVerifying,
    ModelPipelineStage? stage,
    Object? completedModelId = _sentinel,
    Object? error = _sentinel,
    Map<String, ModelDownloadState>? perModelProgress,
  }) {
    return ModelDownloadState(
      downloadingModelId: downloadingModelId == _sentinel
          ? this.downloadingModelId
          : downloadingModelId as String?,
      downloadingModelName: downloadingModelName ?? this.downloadingModelName,
      progress: progress ?? this.progress,
      verificationProgress: verificationProgress ?? this.verificationProgress,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      bytesPerSec: bytesPerSec ?? this.bytesPerSec,
      etaSeconds: etaSeconds ?? this.etaSeconds,
      statusText: statusText ?? this.statusText,
      speedEtaText: speedEtaText ?? this.speedEtaText,
      stageLabel: stageLabel ?? this.stageLabel,
      stageStepText: stageStepText ?? this.stageStepText,
      shaProgressText: shaProgressText ?? this.shaProgressText,
      isDownloading: isDownloading ?? this.isDownloading,
      isVerifying: isVerifying ?? this.isVerifying,
      stage: stage ?? this.stage,
      completedModelId: completedModelId == _sentinel
          ? this.completedModelId
          : completedModelId as String?,
      error: error == _sentinel ? this.error : error as String?,
      perModelProgress: perModelProgress ?? this.perModelProgress,
    );
  }
}

const Object _sentinel = Object();

class ModelDownloadNotifier extends StateNotifier<ModelDownloadState> {
  final Ref _ref;
  StreamSubscription<dynamic>? _streamSub;
  int _lastEmitTimestampMs = 0;

  ModelDownloadNotifier(this._ref) : super(ModelDownloadState());

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  Future<bool> startDownload(String modelId, String modelName) async {
    _streamSub?.cancel();

    final initialModelState = ModelDownloadState(
      downloadingModelId: modelId,
      downloadingModelName: modelName,
      progress: 0.0,
      verificationProgress: 0.0,
      statusText: 'Downloading model...',
      stageLabel: 'Downloading model...',
      stageStepText: 'Step 1/4',
      speedEtaText: 'Connecting...',
      isDownloading: true,
      isVerifying: false,
      stage: ModelPipelineStage.downloading,
    );

    final updatedMap = Map<String, ModelDownloadState>.from(state.perModelProgress);
    updatedMap[modelId] = initialModelState;

    state = initialModelState.copyWith(perModelProgress: updatedMap);

    final completer = Completer<bool>();
    _lastEmitTimestampMs = DateTime.now().millisecondsSinceEpoch;

    _streamSub = DiLangNativeBridge.downloadModelStream(modelId).listen(
      (prog) async {
        final nowMs = DateTime.now().millisecondsSinceEpoch;
        final isStageChange = prog.status.startsWith('Verifying') ||
            prog.status == 'Installed' ||
            prog.status.startsWith('Failed');

        // Throttle rapid stream updates to ~120ms to keep scrolling silky smooth
        if (!isStageChange && (nowMs - _lastEmitTimestampMs) < 120) {
          return;
        }
        _lastEmitTimestampMs = nowMs;

        final bytesDownloadedDouble = prog.bytesDownloaded.toDouble();
        final totalBytesDouble = prog.totalBytes.toDouble();
        final bytesPerSecDouble = prog.bytesPerSec.toDouble();
        final etaSecondsInt = prog.etaSeconds.toDouble().toInt();

        final downloadedMb = (bytesDownloadedDouble / (1024 * 1024)).toStringAsFixed(1);
        final totalMb = (totalBytesDouble / (1024 * 1024)).toStringAsFixed(1);
        final speedMb = (bytesPerSecDouble / (1024 * 1024)).toStringAsFixed(1);

        final ratio = totalBytesDouble > 0
            ? (bytesDownloadedDouble / totalBytesDouble).clamp(0.0, 1.0)
            : 0.0;

        ModelDownloadState updated;

        if (prog.status.startsWith('Verifying')) {
          double verifyRatio = 0.0;
          String shaText = '0 MB / $totalMb MB';

          if (prog.status.contains(':')) {
            final parts = prog.status.split(':')[1].split('/');
            if (parts.length == 2) {
              final done = double.tryParse(parts[0]) ?? 0;
              final tot = double.tryParse(parts[1]) ?? 1;
              if (tot > 0) verifyRatio = (done / tot).clamp(0.0, 1.0);
              shaText = '${done.toInt()} MB / ${tot.toInt()} MB (${(verifyRatio * 100).toInt()}%)';
            }
          } else if (totalBytesDouble > 0 && bytesDownloadedDouble > 0) {
            verifyRatio = (bytesDownloadedDouble / totalBytesDouble).clamp(0.0, 1.0);
            shaText = '$downloadedMb MB / $totalMb MB (${(verifyRatio * 100).toInt()}%)';
          }

          updated = state.copyWith(
            downloadingModelId: modelId,
            downloadingModelName: modelName,
            progress: 1.0,
            verificationProgress: verifyRatio,
            bytesDownloaded: totalBytesDouble,
            totalBytes: totalBytesDouble,
            statusText: 'Calculating SHA-256 checksum...',
            stageLabel: 'Calculating SHA-256 checksum...',
            stageStepText: 'Step 2/4',
            shaProgressText: shaText,
            speedEtaText: 'Verification: $shaText',
            isVerifying: true,
            isDownloading: false,
            stage: ModelPipelineStage.verifying,
          );
        } else if (prog.status == 'Installed') {
          _streamSub?.cancel();
          await _ref.read(installedModelsProvider.notifier).refresh();

          updated = state.copyWith(
            downloadingModelId: modelId,
            downloadingModelName: modelName,
            isDownloading: false,
            isVerifying: false,
            completedModelId: modelId,
            statusText: 'Ready to use',
            stageLabel: 'Ready to use',
            stageStepText: 'Step 4/4',
            speedEtaText: 'Installed & Verified ✓',
            progress: 1.0,
            verificationProgress: 1.0,
            stage: ModelPipelineStage.installed,
          );

          final currentPerModel = Map<String, ModelDownloadState>.from(state.perModelProgress);
          currentPerModel[modelId] = updated;
          state = updated.copyWith(perModelProgress: currentPerModel);

          if (!completer.isCompleted) completer.complete(true);
          return;
        } else if (prog.status.startsWith('Failed')) {
          _streamSub?.cancel();

          updated = state.copyWith(
            downloadingModelId: modelId,
            downloadingModelName: modelName,
            isDownloading: false,
            isVerifying: false,
            error: 'Failed to download $modelName: ${prog.status}',
            statusText: 'Installation Failed',
            stageLabel: 'Installation Failed',
            speedEtaText: 'Failed',
            stage: ModelPipelineStage.failed,
          );

          final currentPerModel = Map<String, ModelDownloadState>.from(state.perModelProgress);
          currentPerModel[modelId] = updated;
          state = updated.copyWith(perModelProgress: currentPerModel);

          if (!completer.isCompleted) completer.complete(false);
          return;
        } else {
          final etaText = etaSecondsInt > 0 ? '$etaSecondsInt s remaining' : 'Calculating ETA...';
          updated = state.copyWith(
            downloadingModelId: modelId,
            downloadingModelName: modelName,
            bytesDownloaded: bytesDownloadedDouble,
            totalBytes: totalBytesDouble,
            bytesPerSec: bytesPerSecDouble,
            etaSeconds: etaSecondsInt,
            statusText: 'Downloading model...',
            stageLabel: 'Downloading model...',
            stageStepText: 'Step 1/4',
            speedEtaText: '$downloadedMb MB / $totalMb MB • $speedMb MB/s • $etaText',
            progress: ratio,
            verificationProgress: 0.0,
            isDownloading: true,
            isVerifying: false,
            stage: ModelPipelineStage.downloading,
          );
        }

        final currentPerModel = Map<String, ModelDownloadState>.from(state.perModelProgress);
        currentPerModel[modelId] = updated;
        state = updated.copyWith(perModelProgress: currentPerModel);
      },
      onError: (err) {
        final updated = state.copyWith(
          isDownloading: false,
          isVerifying: false,
          stage: ModelPipelineStage.failed,
          error: err.toString(),
        );
        final currentPerModel = Map<String, ModelDownloadState>.from(state.perModelProgress);
        currentPerModel[modelId] = updated;
        state = updated.copyWith(perModelProgress: currentPerModel);

        if (!completer.isCompleted) completer.complete(false);
      },
    );

    return completer.future;
  }

  void cancelActiveDownload() {
    _streamSub?.cancel();
    state = ModelDownloadState();
  }
}

final modelDownloadProvider =
    StateNotifierProvider<ModelDownloadNotifier, ModelDownloadState>((ref) {
  return ModelDownloadNotifier(ref);
});

