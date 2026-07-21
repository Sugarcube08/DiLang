import 'dart:async';
import 'package:dilang_learner/learner.dart';
import 'package:dilang_storage/storage.dart';
import '../usecases/identity_and_bootstrap_usecases.dart';

enum BootstrapStage {
  platform,
  logging,
  sqlite,
  secureStorage,
  repositories,
  settings,
  identity,
  localization,
  navigation,
}

class StageMetric {
  final BootstrapStage stage;
  final int durationMs;
  final bool success;
  final String? error;

  const StageMetric({
    required this.stage,
    required this.durationMs,
    required this.success,
    this.error,
  });
}

class PipelineTelemetry {
  final Map<BootstrapStage, StageMetric> stageMetrics;
  final int totalDurationMs;
  final bool recoveryModeActive;

  const PipelineTelemetry({
    required this.stageMetrics,
    required this.totalDurationMs,
    this.recoveryModeActive = false,
  });
}

class BootstrapPipelineResult {
  final BootstrapStatus status;
  final DiLangUser? user;
  final Map<String, String> settings;
  final PipelineTelemetry telemetry;
  final String? errorMessage;

  const BootstrapPipelineResult({
    required this.status,
    this.user,
    this.settings = const {},
    required this.telemetry,
    this.errorMessage,
  });
}

class BootstrapPipeline {
  final SqliteStorageEngine storageEngine;
  final SecureStorageContract secureStorage;
  late final IdentityRepositoryContract identityRepo;
  late final BootstrapRepositoryContract bootstrapRepo;

  BootstrapPipeline({
    required this.storageEngine,
    required this.secureStorage,
    IdentityRepositoryContract? identityRepoOverride,
    BootstrapRepositoryContract? bootstrapRepoOverride,
  }) {
    identityRepo = identityRepoOverride ?? SqliteIdentityRepository(engine: storageEngine);
    bootstrapRepo = bootstrapRepoOverride ?? SqliteBootstrapRepository(engine: storageEngine);
  }

  Future<BootstrapPipelineResult> runPipeline() async {
    final overallStopwatch = Stopwatch()..start();
    final metrics = <BootstrapStage, StageMetric>{};
    bool recoveryActive = false;

    // Stage 1: Platform
    metrics[BootstrapStage.platform] = await _runStage(
      BootstrapStage.platform,
      () async => Future.value(),
    );

    // Stage 2: Logging
    metrics[BootstrapStage.logging] = await _runStage(
      BootstrapStage.logging,
      () async => Future.value(),
    );

    // Stage 3: SQLite
    metrics[BootstrapStage.sqlite] = await _runStage(
      BootstrapStage.sqlite,
      () async {
        final db = storageEngine.db;
        db.select('SELECT 1;');
      },
    );

    if (!metrics[BootstrapStage.sqlite]!.success) {
      recoveryActive = true;
    }

    // Stage 4: Secure Storage
    metrics[BootstrapStage.secureStorage] = await _runStage(
      BootstrapStage.secureStorage,
      () async {
        await secureStorage.write('boot_check', 'ok');
      },
    );

    // Stage 5: Repositories
    metrics[BootstrapStage.repositories] = await _runStage(
      BootstrapStage.repositories,
      () async => Future.value(),
    );

    // Stage 6: Settings
    Map<String, String> loadedSettings = {};
    metrics[BootstrapStage.settings] = await _runStage(
      BootstrapStage.settings,
      () async {
        loadedSettings = await bootstrapRepo.loadSystemSettings();
      },
    );

    // Stage 7: Identity
    DiLangUser? activeUser;
    bool isFirstLaunch = true;
    metrics[BootstrapStage.identity] = await _runStage(
      BootstrapStage.identity,
      () async {
        isFirstLaunch = await bootstrapRepo.isFirstLaunch();
        if (!isFirstLaunch) {
          activeUser = await identityRepo.getActiveUser();
        }
      },
    );

    // Stage 8: Localization
    metrics[BootstrapStage.localization] = await _runStage(
      BootstrapStage.localization,
      () async => Future.value(),
    );

    // Stage 9: Navigation
    metrics[BootstrapStage.navigation] = await _runStage(
      BootstrapStage.navigation,
      () async => Future.value(),
    );

    overallStopwatch.stop();

    final telemetry = PipelineTelemetry(
      stageMetrics: Map.unmodifiable(metrics),
      totalDurationMs: overallStopwatch.elapsedMilliseconds,
      recoveryModeActive: recoveryActive,
    );

    final status = isFirstLaunch || activeUser == null
        ? BootstrapStatus.onboardingRequired
        : BootstrapStatus.authenticatedReady;

    return BootstrapPipelineResult(
      status: status,
      user: activeUser,
      settings: loadedSettings,
      telemetry: telemetry,
    );
  }

  Future<StageMetric> _runStage(
    BootstrapStage stage,
    Future<void> Function() action, {
    int maxRetries = 2,
    Duration timeout = const Duration(milliseconds: 1000),
  }) async {
    final sw = Stopwatch()..start();
    int attempts = 0;
    String? lastError;

    while (attempts <= maxRetries) {
      attempts++;
      try {
        await action().timeout(timeout);
        sw.stop();
        return StageMetric(
          stage: stage,
          durationMs: sw.elapsedMilliseconds,
          success: true,
        );
      } catch (e) {
        lastError = e.toString();
        if (attempts > maxRetries) break;
        await Future.delayed(const Duration(milliseconds: 20));
      }
    }

    sw.stop();
    return StageMetric(
      stage: stage,
      durationMs: sw.elapsedMilliseconds,
      success: false,
      error: lastError,
    );
  }
}
