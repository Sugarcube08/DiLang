import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_extensions.dart';
import '../theme/design_tokens.dart';
import '../theme/di_icons.dart';
import '../components/dilang_button.dart';
import '../components/dilang_card.dart';
import '../components/dilang_progress.dart';
import '../native_bridge.dart';
import '../frb_generated.dart/api.dart' as ffi;

class ModelDownloadScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const ModelDownloadScreen({super.key, required this.onComplete});

  @override
  ConsumerState<ModelDownloadScreen> createState() => _ModelDownloadScreenState();
}

class _ModelDownloadScreenState extends ConsumerState<ModelDownloadScreen> {
  String _currentStep = 'Initializing Production Model Downloader...';
  String _byteProgressText = '0.0 MB / 0.0 MB';
  String _speedEtaText = '';
  double _overallProgress = 0.0;

  bool _gemmaDone = false;
  String _gemmaSha = 'Pending';

  bool _whisperDone = false;
  String _whisperSha = 'Pending';

  bool _piperDone = false;
  String _piperSha = 'Pending';

  bool _isAllComplete = false;
  StreamSubscription<ffi.FfiDownloadProgress>? _streamSub;

  @override
  void initState() {
    super.initState();
    _startProductionDownloadPipeline();
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  Future<void> _startProductionDownloadPipeline() async {
    // Pipeline Model 1: Gemma 3 1B IT (GGUF)
    await _downloadSingleModel(
      modelId: 'gemma-3-1b-it-q4_k_m',
      titleName: 'Gemma 3 1B IT (GGUF)',
      onComplete: (success) {
        if (!mounted) return;
        setState(() {
          _gemmaDone = success;
          _gemmaSha = success ? 'Verified' : 'Failed';
        });
      },
    );

    if (!mounted) return;

    // Pipeline Model 2: Whisper Base (GGML)
    await _downloadSingleModel(
      modelId: 'whisper-base',
      titleName: 'Whisper Base (GGML)',
      onComplete: (success) {
        if (!mounted) return;
        setState(() {
          _whisperDone = success;
          _whisperSha = success ? 'Verified' : 'Failed';
        });
      },
    );

    if (!mounted) return;

    // Pipeline Model 3: Piper Voice (ONNX)
    await _downloadSingleModel(
      modelId: 'piper-en_US-lessac-medium',
      titleName: 'Piper Voice (ONNX)',
      onComplete: (success) {
        if (!mounted) return;
        setState(() {
          _piperDone = success;
          _piperSha = success ? 'Verified' : 'Failed';
        });
      },
    );

    if (!mounted) return;

    final allDone = _gemmaDone && _whisperDone && _piperDone;
    setState(() {
      if (allDone) {
        _currentStep = 'All Models Installed & Verified in SQLite';
        _byteProgressText = 'Complete';
        _speedEtaText = 'Ready for Offline AI Inference';
        _overallProgress = 1.0;
        _isAllComplete = true;
      } else {
        _currentStep = 'Model Installation Incomplete or Failed';
        _byteProgressText = 'Please retry failed model downloads.';
        _speedEtaText = '';
        _isAllComplete = false;
      }
    });
  }

  Future<void> _downloadSingleModel({
    required String modelId,
    required String titleName,
    required void Function(bool success) onComplete,
  }) async {
    final completer = Completer<void>();
    bool hasFinished = false;

    setState(() {
      _currentStep = 'Downloading $titleName...';
      _byteProgressText = 'Connecting to download stream...';
      _speedEtaText = '';
    });

    late final StreamSubscription<ffi.FfiDownloadProgress> sub;
    sub = DiLangNativeBridge.downloadModelStream(modelId).listen(
      (prog) {
        if (!mounted) return;

        final downloadedMb = (prog.bytesDownloaded.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final totalMb = (prog.totalBytes.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final speedMb = (prog.bytesPerSec.toInt() / (1024 * 1024)).toStringAsFixed(1);
        final etaSecs = prog.etaSeconds.toInt();

        final ratio = prog.totalBytes.toInt() > 0
            ? (prog.bytesDownloaded.toInt() / prog.totalBytes.toInt()).clamp(0.0, 1.0)
            : 0.0;

        setState(() {
          _byteProgressText = '$downloadedMb MB / $totalMb MB';
          _speedEtaText = '$speedMb MB/s • ${etaSecs}s remaining';
          _overallProgress = ratio;
        });

        if (prog.status == 'Verifying') {
          setState(() {
            _currentStep = 'Verifying SHA-256 Checksum for $titleName...';
            _speedEtaText = 'Calculating Sha256 Hash...';
          });
        } else if (prog.status == 'Installed') {
          hasFinished = true;
          onComplete(true);
          sub.cancel();
          if (!completer.isCompleted) completer.complete();
        } else if (prog.status == 'Failed') {
          hasFinished = true;
          onComplete(false);
          sub.cancel();
          if (!completer.isCompleted) completer.complete();
        }
      },
      onError: (err) {
        if (!hasFinished) {
          hasFinished = true;
          onComplete(false);
        }
        sub.cancel();
        if (!completer.isCompleted) completer.complete();
      },
      onDone: () {
        if (!hasFinished) {
          hasFinished = true;
          onComplete(false);
        }
        if (!completer.isCompleted) completer.complete();
      },
    );

    await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Model Manager')),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Manager',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Downloading local inference models and verifying SHA-256 checksums in SQLite.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),

            DiLangCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentStep,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _byteProgressText,
                        style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      if (_speedEtaText.isNotEmpty)
                        Text(
                          _speedEtaText,
                          style: TextStyle(color: colors.textSecondary, fontSize: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DiLangGradientProgress(progress: _overallProgress),
                  const SizedBox(height: 24),
                  _buildModelRow('Gemma 3 1B IT (GGUF)', _gemmaDone, _gemmaSha),
                  const SizedBox(height: 12),
                  _buildModelRow('Whisper Base (GGML)', _whisperDone, _whisperSha),
                  const SizedBox(height: 12),
                  _buildModelRow('Piper Voice (ONNX)', _piperDone, _piperSha),
                ],
              ),
            ),
            const Spacer(),

            if (_isAllComplete)
              SizedBox(
                width: double.infinity,
                child: DiLangButton(
                  label: 'Complete Onboarding',
                  icon: DiIcons.check,
                  onPressed: () async {
                    await DiLangNativeBridge.setOnboardingStep('Completed');
                    widget.onComplete();
                  },
                ),
              )
            else ...[
              if (_gemmaSha == 'Failed' || _whisperSha == 'Failed' || _piperSha == 'Failed')
                SizedBox(
                  width: double.infinity,
                  child: DiLangButton(
                    label: 'Retry Model Download',
                    icon: DiIcons.refresh,
                    onPressed: _startProductionDownloadPipeline,
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: DiLangButton(
                  label: 'Download Later in Settings',
                  icon: DiIcons.settings,
                  variant: DiLangButtonVariant.secondary,
                  onPressed: () async {
                    await DiLangNativeBridge.setOnboardingStep('Completed');
                    widget.onComplete();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModelRow(String name, bool isDone, String shaStatus) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          isDone ? DiIcons.check : DiIcons.time,
          size: 18,
          color: isDone ? Colors.green : colors.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 10),
        Text(
          name,
          style: TextStyle(
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
            color: isDone ? Colors.white : colors.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const Spacer(),
        Text(
          'SHA256: $shaStatus',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDone ? Colors.green : colors.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
