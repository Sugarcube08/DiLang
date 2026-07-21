import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';

void main() {
  group('FTUE Onboarding Flow & Relaunch Integration Tests', () {
    late SqliteStorageEngine storageEngine;
    late SqliteIdentityRepository identityRepo;
    late SqliteBootstrapRepository bootstrapRepo;
    late CreateIdentityUseCase createIdentityUseCase;
    late FtueOnboardingController ftueController;

    setUp(() {
      storageEngine = SqliteStorageEngine.inMemory();
      identityRepo = SqliteIdentityRepository(engine: storageEngine);
      bootstrapRepo = SqliteBootstrapRepository(engine: storageEngine);
      createIdentityUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );
      ftueController = FtueOnboardingController();
    });

    tearDown(() {
      storageEngine.dispose();
    });

    test('1. FTUE State Machine steps sequentially through 10 screens', () {
      expect(ftueController.state.step, equals(FtueStep.welcome));

      ftueController.nextStep(); // -> identity
      expect(ftueController.state.step, equals(FtueStep.identity));

      // Attempting to proceed without username fails with error
      ftueController.nextStep();
      expect(ftueController.state.errorMessage, isNotNull);

      // Provide valid identity
      ftueController.updateIdentity('sugarcube', 'pass123', email: 'sc@dilang.ai');
      ftueController.nextStep(); // -> sync
      expect(ftueController.state.step, equals(FtueStep.sync));

      ftueController.setSyncEnabled(true);
      ftueController.nextStep(); // -> language
      expect(ftueController.state.step, equals(FtueStep.language));

      ftueController.setLanguages('English', 'German');
      ftueController.nextStep(); // -> goal
      expect(ftueController.state.step, equals(FtueStep.goal));

      ftueController.setGoal('Conversation');
      ftueController.nextStep(); // -> startingPoint
      expect(ftueController.state.step, equals(FtueStep.startingPoint));

      ftueController.setStartingPoint('beginning');
      ftueController.nextStep(); // -> aiSetup
      expect(ftueController.state.step, equals(FtueStep.aiSetup));

      ftueController.nextStep(); // -> resources
      expect(ftueController.state.step, equals(FtueStep.resources));
      expect(ftueController.state.aiDownloaded, isTrue);

      ftueController.nextStep(); // -> success
      expect(ftueController.state.step, equals(FtueStep.success));
      expect(ftueController.state.resourcesDownloaded, isTrue);

      ftueController.nextStep(); // -> completed
      expect(ftueController.state.step, equals(FtueStep.completed));
    });

    test('2. Complete Onboarding Flow persists directly to SQLite and restores state on Relaunch', () async {
      // 1. User advances through FTUE controller
      ftueController.updateIdentity('learner1', 'pass123', email: 'l1@dilang.ai');
      ftueController.setLanguages('English', 'German');
      ftueController.setGoal('Fluency');

      // 2. Write to SQLite
      final user = await createIdentityUseCase.execute(
        username: ftueController.state.username,
        email: ftueController.state.email,
        displayName: 'Learner One',
        nativeLanguage: ftueController.state.nativeLanguage,
        targetLanguage: ftueController.state.targetLanguage,
        cefrLevel: 'A1',
        learningGoal: ftueController.state.goal,
        dailyGoalMinutes: 15,
      );

      expect(user.username, equals('learner1'));

      // 3. Simulate App Restart (Relaunching Bootstrap Pipeline)
      final pipeline = BootstrapPipeline(
        storageEngine: storageEngine,
        secureStorage: MemorySecureStorage(),
        identityRepoOverride: identityRepo,
        bootstrapRepoOverride: bootstrapRepo,
      );

      final bootResult = await pipeline.runPipeline();

      // 4. Verify exact state restoration
      expect(bootResult.status, equals(BootstrapStatus.authenticatedReady));
      expect(bootResult.user, isNotNull);
      expect(bootResult.user!.username, equals('learner1'));
      expect(bootResult.user!.profile.nativeLanguage, equals('English'));
      expect(bootResult.user!.primaryLanguageProfile?.targetLanguage, equals('German'));
      expect(bootResult.user!.primaryLanguageProfile?.learningGoal, equals('Fluency'));
    });
  });
}
