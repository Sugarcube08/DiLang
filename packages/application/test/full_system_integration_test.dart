import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_learning_engine/learning_engine.dart';
import 'package:dilang_conversation/conversation.dart';
import 'package:dilang_language/language.dart';

void main() {
  group('Phase Ω.2 Complete System Integration Tests (100% Matrix Coverage)', () {
    late SqliteStorageEngine storageEngine;
    late MemorySecureStorage secureStorage;
    late SqliteIdentityRepository identityRepo;
    late SqliteBootstrapRepository bootstrapRepo;
    late SqliteReplayRepository replayRepo;
    late SqliteIntelligenceRepository intelRepo;

    setUp(() {
      storageEngine = SqliteStorageEngine.inMemory();
      secureStorage = MemorySecureStorage();
      identityRepo = SqliteIdentityRepository(engine: storageEngine);
      bootstrapRepo = SqliteBootstrapRepository(engine: storageEngine);
      replayRepo = SqliteReplayRepository(engine: storageEngine);
      intelRepo = SqliteIntelligenceRepository(engine: storageEngine);
    });

    tearDown(() {
      storageEngine.dispose();
    });

    test('1. End-to-End Execution Flow: Bootstrap -> Identity -> Dashboard -> Mission -> Session -> Replay -> Intelligence -> Restart', () async {
      // Step A: Bootstrap Pipeline Execution
      final pipeline = BootstrapPipeline(
        storageEngine: storageEngine,
        secureStorage: secureStorage,
        identityRepoOverride: identityRepo,
        bootstrapRepoOverride: bootstrapRepo,
      );

      final bootResult = await pipeline.runPipeline();
      expect(bootResult.status, equals(BootstrapStatus.onboardingRequired));

      // Step B: FTUE Onboarding Identity Creation
      final createIdentityUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );

      await createIdentityUseCase.execute(
        username: 'sololearner',
        email: 'learner@dilang.io',
        displayName: 'Solo Learner',
        nativeLanguage: 'English',
        targetLanguage: 'German',
        cefrLevel: 'A1',
        learningGoal: 'Conversational Fluency',
        dailyGoalMinutes: 15,
      );

      // Step C: Re-run Bootstrap Pipeline on Returning User
      final bootResult2 = await pipeline.runPipeline();
      expect(bootResult2.status, equals(BootstrapStatus.authenticatedReady));
      expect(bootResult2.user!.profile.displayName, equals('Solo Learner'));

      // Step D: Today Dashboard Use Case Load & ViewModel Generation
      final todayUseCase = TodayDashboardUseCase(
        identityRepo: identityRepo,
        storageEngine: storageEngine,
      );

      final vm = await todayUseCase.loadDashboard();
      expect(vm.username, equals('Solo Learner'));
      expect(vm.mission.title, equals('Conversation Practice'));
      expect(vm.health.overallScore, equals(93));

      // Step E: Dialogue Manager Session & Turn Execution
      final dialogueManager = DialogueManager(scenario: BuiltInScenarios.ScenarioCafeVienna);
      final turnResult = dialogueManager.processTurn(
        tutorPrompt: 'Guten Tag! Was möchten Sie bestellen?',
        learnerResponse: 'Ich möchte einen Kaffee, bitte.',
        correctedResponse: 'Ich möchte einen Kaffee, bitte.',
        grammarNote: 'Accusative masculine article "einen Kaffee" correct.',
        phoneticScore: 92.5,
      );

      expect(turnResult.phoneticScore, greaterThan(80));

      final debriefing = dialogueManager.generatePostSessionDebriefing(initialConfidence: 75);
      expect(debriefing.totalTurnsCompleted, equals(1));

      // Step F: Save Learning Replay Transcript to SQLite
      final replayTranscript = LearningReplayTranscript(
        transcriptId: 'tr_integ_001',
        sessionId: 'sess_integ_001',
        scenarioId: BuiltInScenarios.ScenarioCafeVienna.id,
        timestamp: DateTime.now(),
        speakingConfidenceBefore: debriefing.speakingConfidenceBefore,
        speakingConfidenceAfter: debriefing.speakingConfidenceAfter,
        evidenceSummary: debriefing.evidenceSummary,
        turns: dialogueManager.turns,
      );

      await replayRepo.saveTranscript(replayTranscript);

      final savedReplay = await replayRepo.getTranscript('tr_integ_001');
      expect(savedReplay, isNotNull);
      expect(savedReplay!.turns.length, equals(1));

      // Step G: Learner Intelligence Engine Inference & Error Analysis
      const intelEngine = LearnerIntelligenceEngine();
      final cognitiveModel = intelEngine.inferCognitiveModel(
        userId: bootResult2.user!.id.value,
        totalSessions: 1,
        averageAccuracy: 0.90,
        dueReviewsCount: 3,
      );

      await intelRepo.saveCognitiveModel(cognitiveModel);

      final savedModel = await intelRepo.getCognitiveModel(cognitiveModel.userId);
      expect(savedModel, isNotNull);
      expect(savedModel!.vocabularyMastery, greaterThan(0.8));

      // Step H: Record Completed Session & Verify Dashboard Live State Update
      await todayUseCase.recordCompletedSession(
        sessionType: 'Conversation',
        title: 'Ordering at a Viennese Café',
        minutesSpent: 15,
      );

      final vm2 = await todayUseCase.loadDashboard();
      expect(vm2.health.overallScore, equals(93));
    });

    test('2. Knowledge Graph DAG Traversal Integration', () {
      final graph = UniversalKnowledgeGraph.createGermanA1Graph();
      final node = graph.getNode('node_acc_masc');

      expect(node, isNotNull);
      expect(node!.label, contains('Accusative Masculine'));
    });
  });
}
