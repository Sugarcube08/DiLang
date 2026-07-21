import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_learning_engine/learning_engine.dart';
import 'package:dilang_conversation/conversation.dart';

void main() {
  group('Phase Ω.3 Production Readiness & Black-Box Validation Suite', () {
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

    test('Stage 1 & 2: Black-Box Fault Tolerance & Corrupted DB Auto-Recovery', () async {
      // 1. Fresh Install Bootstrap
      final pipeline = BootstrapPipeline(
        storageEngine: storageEngine,
        secureStorage: secureStorage,
        identityRepoOverride: identityRepo,
        bootstrapRepoOverride: bootstrapRepo,
      );

      final boot1 = await pipeline.runPipeline();
      expect(boot1.status, equals(BootstrapStatus.onboardingRequired));

      // 2. Onboarding Profile Creation
      final createIdentityUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );

      await createIdentityUseCase.execute(
        username: 'alpha_tester',
        email: 'tester@dilang.io',
        displayName: 'Alpha Tester',
        nativeLanguage: 'English',
        targetLanguage: 'German',
        cefrLevel: 'A1',
        learningGoal: 'Travel',
        dailyGoalMinutes: 15,
      );

      // 3. Relaunch & State Verification
      final boot2 = await pipeline.runPipeline();
      expect(boot2.status, equals(BootstrapStatus.authenticatedReady));
      expect(boot2.user!.profile.displayName, equals('Alpha Tester'));

      // 4. Force Database Corruption Simulation & Auto-Recovery
      storageEngine.db.execute('DROP TABLE users;');
      final bootRecover = await pipeline.runPipeline();
      expect(bootRecover.status, equals(BootstrapStatus.onboardingRequired));
    });

    test('Stage 3 & 4: Performance Benchmarking & Telemetry Metrics', () async {
      final sw = Stopwatch()..start();

      final pipeline = BootstrapPipeline(
        storageEngine: storageEngine,
        secureStorage: secureStorage,
        identityRepoOverride: identityRepo,
        bootstrapRepoOverride: bootstrapRepo,
      );

      final result = await pipeline.runPipeline();
      sw.stop();

      // Benchmark targets: Cold startup < 1000ms, pipeline execution < 200ms
      expect(sw.elapsedMilliseconds, lessThan(1000));
      expect(result.telemetry.totalDurationMs, lessThan(200));
    });

    test('Stage 5 & 6: Content & AI Persona Evaluation Regression', () {
      final scenario = BuiltInScenarios.ScenarioCafeVienna;
      expect(scenario.cefrLevel, equals('A1'));
      expect(scenario.personaName, equals('Greta'));

      final dialogueManager = DialogueManager(scenario: scenario);
      final briefing = dialogueManager.generatePreSessionBriefing();

      expect(briefing.preSessionCoaching, contains('accusative articles'));
      expect(briefing.culturalTip, contains('Vienna'));
    });

    test('Stage 9: Alpha Acceptance Gate Statement Verification', () async {
      // "A new user can install DiLang on Linux or Android, complete onboarding, finish a learning session, close the application, reopen it, and continue learning without assistance or unexpected failures."
      final pipeline = BootstrapPipeline(
        storageEngine: storageEngine,
        secureStorage: secureStorage,
        identityRepoOverride: identityRepo,
        bootstrapRepoOverride: bootstrapRepo,
      );

      // Step A: Install & First Launch
      final res1 = await pipeline.runPipeline();
      expect(res1.status, equals(BootstrapStatus.onboardingRequired));

      // Step B: Complete Onboarding
      final createIdentityUseCase = CreateIdentityUseCase(
        identityRepo: identityRepo,
        bootstrapRepo: bootstrapRepo,
      );

      await createIdentityUseCase.execute(
        username: 'learner_alpha',
        email: 'alpha@dilang.io',
        displayName: 'Learner Alpha',
        nativeLanguage: 'English',
        targetLanguage: 'German',
        cefrLevel: 'A1',
        learningGoal: 'Fluency',
        dailyGoalMinutes: 15,
      );

      // Step C: Learning Session & Replay Persisted
      final dialogueManager = DialogueManager(scenario: BuiltInScenarios.ScenarioCafeVienna);
      dialogueManager.processTurn(
        tutorPrompt: 'Guten Tag! Was darf es sein?',
        learnerResponse: 'Einen Kaffee, bitte.',
        correctedResponse: 'Einen Kaffee, bitte.',
        grammarNote: 'Accusative masculine article correct.',
        phoneticScore: 95.0,
      );

      final debriefing = dialogueManager.generatePostSessionDebriefing(initialConfidence: 80);
      final replayTranscript = LearningReplayTranscript(
        transcriptId: 'tr_alpha_01',
        sessionId: 'sess_alpha_01',
        scenarioId: BuiltInScenarios.ScenarioCafeVienna.id,
        timestamp: DateTime.now(),
        speakingConfidenceBefore: debriefing.speakingConfidenceBefore,
        speakingConfidenceAfter: debriefing.speakingConfidenceAfter,
        evidenceSummary: debriefing.evidenceSummary,
        turns: dialogueManager.turns,
      );

      await replayRepo.saveTranscript(replayTranscript);

      // Step D: App Restart & State Restored
      final res2 = await pipeline.runPipeline();
      expect(res2.status, equals(BootstrapStatus.authenticatedReady));
      expect(res2.user!.profile.displayName, equals('Learner Alpha'));

      final savedReplay = await replayRepo.getTranscript('tr_alpha_01');
      expect(savedReplay, isNotNull);
      expect(savedReplay!.turns.first.learnerResponse, equals('Einen Kaffee, bitte.'));
    });
  });
}
