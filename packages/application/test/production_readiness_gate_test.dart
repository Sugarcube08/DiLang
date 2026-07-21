import 'dart:io';
import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';

void main() {
  group('Production Readiness Gate & Bootstrap Pipeline Tests', () {
    late SqliteStorageEngine storageEngine;
    late MemorySecureStorage secureStorage;
    late BootstrapPipeline pipeline;
    late SqliteIdentityRepository identityRepo;
    late SqliteBootstrapRepository bootstrapRepo;

    setUp(() {
      storageEngine = SqliteStorageEngine.inMemory();
      secureStorage = MemorySecureStorage();
      identityRepo = SqliteIdentityRepository(engine: storageEngine);
      bootstrapRepo = SqliteBootstrapRepository(engine: storageEngine);
      pipeline = BootstrapPipeline(
        storageEngine: storageEngine,
        secureStorage: secureStorage,
        identityRepoOverride: identityRepo,
        bootstrapRepoOverride: bootstrapRepo,
      );
    });

    tearDown(() {
      storageEngine.dispose();
    });

    test('1. Fresh Install Test: Pipeline returns onboardingRequired', () async {
      final result = await pipeline.runPipeline();

      expect(result.status, equals(BootstrapStatus.onboardingRequired));
      expect(result.user, isNull);
      expect(result.telemetry.stageMetrics.length, equals(9));
      expect(result.telemetry.totalDurationMs, lessThan(200));

      for (final stage in BootstrapStage.values) {
        expect(result.telemetry.stageMetrics[stage]?.success, isTrue);
      }
    });

    test('2. Returning User Test: Persisted Identity restored across startup', () async {
      // 1. Initial Fresh Boot
      final boot1 = await pipeline.runPipeline();
      expect(boot1.status, equals(BootstrapStatus.onboardingRequired));

      // 2. User onboarding & identity creation
      final createUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );

      final user = await createUseCase.execute(
        username: 'sugarcube',
        email: 'user@dilang.ai',
        displayName: 'Sugar Cube',
        nativeLanguage: 'en',
        targetLanguage: 'de',
        cefrLevel: 'A1',
        learningGoal: 'fluency',
        dailyGoalMinutes: 15,
      );

      expect(user.username, equals('sugarcube'));

      // 3. Second Boot (simulating app relaunch with existing SQLite DB)
      final boot2 = await pipeline.runPipeline();
      expect(boot2.status, equals(BootstrapStatus.authenticatedReady));
      expect(boot2.user, isNotNull);
      expect(boot2.user!.username, equals('sugarcube'));
      expect(boot2.user!.profile.displayName, equals('Sugar Cube'));
      expect(boot2.user!.primaryLanguageProfile?.targetLanguage, equals('de'));
    });

    test('3. Corrupted Database Recovery Test: Recreates pristine DB state on corruption', () async {
      final tempDir = Directory.systemTemp.createTempSync('dilang_test_db');
      final dbPath = '${tempDir.path}/corrupt_test.db';

      // 1. Create initial DB and file
      final fileEngine = SqliteStorageEngine(dbPath: dbPath);
      fileEngine.dispose();

      // 2. Corrupt file content
      File(dbPath).writeAsStringSync('CORRUPTED_INVALID_SQLITE_HEADER');

      // 3. Re-open via SqliteStorageEngine -> Integrity Check auto-recovers
      final recoveredEngine = SqliteStorageEngine(dbPath: dbPath);
      final recoveredRepo = SqliteIdentityRepository(engine: recoveredEngine);
      final activeUser = await recoveredRepo.getActiveUser();

      expect(activeUser, isNull);
      recoveredEngine.dispose();

      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('4. Secure Storage Key Isolation Test', () async {
      await secureStorage.write('sync_token_user_1', 'sec_tok_998877');
      final val = await secureStorage.read('sync_token_user_1');
      expect(val, equals('sec_tok_998877'));

      await secureStorage.delete('sync_token_user_1');
      final valAfterDelete = await secureStorage.read('sync_token_user_1');
      expect(valAfterDelete, isNull);
    });

    test('5. Telemetry Metric Timing Test (< 200 ms target)', () async {
      final result = await pipeline.runPipeline();
      expect(result.telemetry.totalDurationMs, lessThan(200));

      final sqlMetric = result.telemetry.stageMetrics[BootstrapStage.sqlite];
      expect(sqlMetric, isNotNull);
      expect(sqlMetric!.success, isTrue);
      expect(sqlMetric.durationMs, lessThan(50));
    });
  });
}
