import 'dart:io';
import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';

void main() {
  late String dbPath;

  setUp(() {
    final tempDir = Directory.systemTemp.createTempSync('dilang_sync_test_');
    dbPath = '${tempDir.path}/dilang_storage.db';
  });

  tearDown(() {
    final file = File(dbPath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Phase 1 Learner Identity Runtime & State Synchronization', () {
    test('Live Profile Editing updates state & SQLite without process restart', () async {
      final eventBus = EventBus();
      final engine = SqliteStorageEngine(dbPath: dbPath);
      final identityRepo = SqliteIdentityRepository(engine: engine);
      final replayRepo = SqliteReplayRepository(engine: engine);
      final intelRepo = SqliteIntelligenceRepository(engine: engine);

      final kernel = DiLangRuntimeKernel(
        eventBus: eventBus,
        storageEngine: engine,
        identityRepo: identityRepo,
        replayRepo: replayRepo,
        intelRepo: intelRepo,
      );

      // 1. Create Initial Profile
      await kernel.createLearnerProfile(
        name: 'Learner',
        mediumLanguage: 'English',
        targetLanguage: 'German',
        brainModel: 'Conversation First',
        learningGoal: 'Daily Conversation',
        aiCoachPersona: 'Friendly',
      );

      expect(kernel.state.learner?.profile.displayName, equals('Learner'));
      expect(kernel.state.learner?.primaryLanguageProfile?.targetLanguage, equals('German'));

      // 2. Edit Profile Name & Target Language Live
      await kernel.updateSettings(
        displayName: 'SugarCube',
        nativeLanguage: 'English',
        targetLanguage: 'French',
        brainModel: 'Grammar First',
        aiCoachPersona: 'Strict',
      );

      // Verify Instant Kernel State Update
      expect(kernel.state.learner?.profile.displayName, equals('SugarCube'));
      expect(kernel.state.learner?.primaryLanguageProfile?.targetLanguage, equals('French'));
      expect(kernel.state.learner?.primaryLanguageProfile?.brainModel, equals('Grammar First'));

      // Verify SQLite Persistence
      final dbUser = await identityRepo.getActiveUser();
      expect(dbUser, isNotNull);
      expect(dbUser!.profile.displayName, equals('SugarCube'));
      expect(dbUser.primaryLanguageProfile?.targetLanguage, equals('French'));

      engine.dispose();
    });

    test('Soft Logout resets runtime kernel & preserves SQLite identity', () async {
      final eventBus = EventBus();
      final engine = SqliteStorageEngine(dbPath: dbPath);
      final identityRepo = SqliteIdentityRepository(engine: engine);
      final replayRepo = SqliteReplayRepository(engine: engine);
      final intelRepo = SqliteIntelligenceRepository(engine: engine);

      final kernel = DiLangRuntimeKernel(
        eventBus: eventBus,
        storageEngine: engine,
        identityRepo: identityRepo,
        replayRepo: replayRepo,
        intelRepo: intelRepo,
      );

      await kernel.createLearnerProfile(
        name: 'UserSoft',
        mediumLanguage: 'English',
        targetLanguage: 'German',
        brainModel: 'Conversation First',
        learningGoal: 'Daily Conversation',
        aiCoachPersona: 'Friendly',
      );

      expect(kernel.state.isOnboardingRequired, isFalse);

      // Execute Soft Logout
      await kernel.softLogout();

      expect(kernel.state.isOnboardingRequired, isTrue);
      expect(kernel.state.learner, isNull);
      expect(kernel.state.availableProfiles.length, equals(1));
      expect(kernel.state.availableProfiles.first.profile.displayName, equals('UserSoft'));

      engine.dispose();
    });

    test('Factory Reset wipes SQLite database file & resets kernel state', () async {
      final eventBus = EventBus();
      final engine = SqliteStorageEngine(dbPath: dbPath);
      final identityRepo = SqliteIdentityRepository(engine: engine);
      final replayRepo = SqliteReplayRepository(engine: engine);
      final intelRepo = SqliteIntelligenceRepository(engine: engine);

      final kernel = DiLangRuntimeKernel(
        eventBus: eventBus,
        storageEngine: engine,
        identityRepo: identityRepo,
        replayRepo: replayRepo,
        intelRepo: intelRepo,
      );

      await kernel.createLearnerProfile(
        name: 'UserReset',
        mediumLanguage: 'English',
        targetLanguage: 'German',
        brainModel: 'Conversation First',
        learningGoal: 'Daily Conversation',
        aiCoachPersona: 'Friendly',
      );

      expect(File(dbPath).existsSync(), isTrue);

      // Execute Factory Reset
      await kernel.factoryReset();

      expect(kernel.state.isOnboardingRequired, isTrue);
      expect(kernel.state.learner, isNull);
      expect(kernel.state.availableProfiles.isEmpty, isTrue);
      expect(File(dbPath).existsSync(), isFalse);
    });
  });
}
