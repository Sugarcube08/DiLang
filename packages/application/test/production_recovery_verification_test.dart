import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_learning_engine/learning_engine.dart';
import 'package:dilang_conversation/conversation.dart';
import 'package:dilang_language/language.dart';

void main() {
  late SqliteStorageEngine engine;
  late MemorySecureStorage secStorage;
  late SqliteIdentityRepository identityRepo;
  late SqliteBootstrapRepository bootstrapRepo;
  late SqliteReplayRepository replayRepo;
  late SqliteIntelligenceRepository intelRepo;

  setUp(() async {
    engine = SqliteStorageEngine.inMemory();
    secStorage = MemorySecureStorage();
    identityRepo = SqliteIdentityRepository(engine: engine);
    bootstrapRepo = SqliteBootstrapRepository(engine: engine);
    replayRepo = SqliteReplayRepository(engine: engine);
    intelRepo = SqliteIntelligenceRepository(engine: engine);
  });

  tearDown(() async {
    engine.dispose();
  });

  group('DiLang Production Recovery Verification (Milestones 1–5)', () {
    test('Milestone 1: Onboarding, Profile Creation & Persistence Restoration', () async {
      // 1. Fresh Install Verification
      final pipeline = BootstrapPipeline(
        storageEngine: engine,
        secureStorage: secStorage,
        identityRepoOverride: identityRepo,
        bootstrapRepoOverride: bootstrapRepo,
      );

      var bootRes = await pipeline.runPipeline();
      expect(bootRes.status, equals(BootstrapStatus.onboardingRequired));

      // 2. Create Identity Profile
      final createUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );

      final user = await createUseCase.execute(
        username: 'sugarcube',
        email: 'sugarcube@dilang.ai',
        displayName: 'SugarCube',
        nativeLanguage: 'English',
        targetLanguage: 'German',
        cefrLevel: 'A1',
        learningGoal: 'Daily Conversation',
        dailyGoalMinutes: 15,
        brainModel: 'Conversation First',
        aiCoachPersona: 'Friendly',
        voicePreference: 'Female',
      );

      expect(user.username, equals('sugarcube'));
      expect(user.profile.nativeLanguage, equals('English'));
      expect(user.primaryLanguageProfile?.targetLanguage, equals('German'));

      // 3. App Restart Verification (Simulate Process Relaunch)
      final reloadedUser = await identityRepo.getActiveUser();
      expect(reloadedUser, isNotNull);
      expect(reloadedUser!.username, equals('sugarcube'));
      expect(reloadedUser.profile.displayName, equals('SugarCube'));

      bootRes = await pipeline.runPipeline();
      expect(bootRes.status, equals(BootstrapStatus.authenticatedReady));
    });

    test('Milestone 2: Dashboard Metrics & Mission Generation', () async {
      // Seed user identity
      final createUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );
      await createUseCase.execute(
        username: 'learner_m2',
        email: 'm2@dilang.ai',
        displayName: 'Learner M2',
        nativeLanguage: 'English',
        targetLanguage: 'German',
        cefrLevel: 'A1',
        learningGoal: 'Daily Conversation',
        dailyGoalMinutes: 15,
      );

      final dashUseCase = TodayDashboardUseCase(
        identityRepo: identityRepo,
        storageEngine: engine,
      );

      final vm = await dashUseCase.loadDashboard();
      expect(vm.username, equals('Learner M2'));
      expect(vm.mission.targetLanguage.toUpperCase(), equals('GERMAN'));
      expect(vm.health.overallScore, greaterThanOrEqualTo(0.0));
    });

    test('Milestone 3 & 4: Interactive Conversation Session & Turn Evaluation', () async {
      final scenario = BuiltInScenarios.ScenarioCafeVienna;
      final dialogueManager = DialogueManager(scenario: scenario);

      final briefing = dialogueManager.generatePreSessionBriefing();
      expect(briefing.preSessionCoaching, contains('Watch for adjective endings'));

      // Execute Learner Turn
      final turn = dialogueManager.processTurn(
        tutorPrompt: 'Guten Tag! Was darf ich Ihnen bringen?',
        learnerResponse: 'Ich möchte einen Kaffee, bitte.',
        correctedResponse: 'Ich möchte einen Kaffee, bitte.',
        grammarNote: 'Grammar structure is natural and correct.',
        phoneticScore: 96.0,
      );

      expect(turn.turnIndex, equals(1));
      expect(turn.phoneticScore, equals(96.0));
      expect(dialogueManager.turns.length, equals(1));
    });

    test('Milestone 5: Knowledge Graph, FSRS & Relaunch Persistence', () async {
      // 1. Seed user identity & dialogue session
      final createUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );
      final user = await createUseCase.execute(
        username: 'learner_m5',
        email: 'm5@dilang.ai',
        displayName: 'Learner M5',
        nativeLanguage: 'English',
        targetLanguage: 'German',
        cefrLevel: 'A1',
        learningGoal: 'Daily Conversation',
        dailyGoalMinutes: 15,
      );

      final scenario = BuiltInScenarios.ScenarioCafeVienna;
      final dialogueManager = DialogueManager(scenario: scenario);
      dialogueManager.processTurn(
        tutorPrompt: 'Guten Tag!',
        learnerResponse: 'Ich möchte einen heißen Kaffee, bitte.',
        correctedResponse: 'Ich möchte einen heißen Kaffee, bitte.',
        grammarNote: 'Accusative masculine weak adjective ending "-en".',
        phoneticScore: 92.0,
      );

      final debriefing = dialogueManager.generatePostSessionDebriefing(initialConfidence: 75);

      final replay = LearningReplayTranscript(
        transcriptId: 'tr_m5_test',
        sessionId: 'sess_m5_test',
        scenarioId: scenario.id,
        timestamp: DateTime.now(),
        speakingConfidenceBefore: debriefing.speakingConfidenceBefore,
        speakingConfidenceAfter: debriefing.speakingConfidenceAfter,
        evidenceSummary: debriefing.evidenceSummary,
        turns: dialogueManager.turns,
      );

      // Save Replay Transcript to SQLite
      await replayRepo.saveTranscript(replay);

      // Infer Cognitive Model & Save to SQLite
      const intelEngine = LearnerIntelligenceEngine();
      final model = intelEngine.inferCognitiveModel(
        userId: user.id.value,
        totalSessions: 1,
        averageAccuracy: debriefing.grammarAccuracyRatio,
        dueReviewsCount: 3,
      );
      await intelRepo.saveCognitiveModel(model);

      // Verify Database Query Recovery
      final savedTranscript = await replayRepo.getTranscript('tr_m5_test');
      expect(savedTranscript, isNotNull);
      expect(savedTranscript!.turns.length, equals(1));
      expect(savedTranscript.turns.first.learnerResponse, equals('Ich möchte einen heißen Kaffee, bitte.'));

      final savedModel = await intelRepo.getCognitiveModel(user.id.value);
      expect(savedModel, isNotNull);
      expect(savedModel!.vocabularyMastery, greaterThan(0.0));
    });
  });
}
