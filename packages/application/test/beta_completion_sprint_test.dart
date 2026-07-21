import 'dart:io';
import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_conversation/conversation.dart';

void main() {
  late String dbPath;

  setUp(() {
    final tempDir = Directory.systemTemp.createTempSync('dilang_beta_test_');
    dbPath = '${tempDir.path}/dilang_storage.db';
  });

  tearDown(() {
    final file = File(dbPath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Phase 3 — Beta Completion Sprint (v2.4-beta) Verification', () {
    test('Definition of Done 1: End-to-End Account Restoration Across Logout & Login', () async {
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

      // 1. Create Profile
      await kernel.createLearnerProfile(
        name: 'BetaUser',
        mediumLanguage: 'English',
        targetLanguage: 'German',
        brainModel: 'Conversation First',
        learningGoal: 'Daily Conversation',
        aiCoachPersona: 'Friendly',
      );

      // 2. Complete Dialogue Session
      kernel.startSession(BuiltInScenarios.ScenarioCafeVienna);
      await kernel.submitTurn('Ich möchte einen heißen Kaffee, bitte.');
      await kernel.completeSession();

      expect(kernel.state.completedSessionsCount, equals(1));

      // 3. Soft Logout
      await kernel.softLogout();
      expect(kernel.state.isOnboardingRequired, isTrue);

      // 4. Re-Initialize Account (Login)
      await kernel.initializeRuntime();
      expect(kernel.state.isOnboardingRequired, isFalse);
      expect(kernel.state.learner?.profile.displayName, equals('BetaUser'));
      expect(kernel.state.completedSessionsCount, equals(1));

      engine.dispose();
    });

    test('Definition of Done 2 & 3: Production LLM Provider & Speech Runtime Operation', () async {
      final llmProvider = ProductionLlmProvider();
      expect(llmProvider.providerId, equals('production_llm'));

      final reply = await llmProvider.generateCompletion(
        systemPrompt: 'You are a German tutor.',
        userPrompt: 'Ich möchte einen heißen Kaffee, bitte.',
      );
      expect(reply.isNotEmpty, isTrue);

      final speechService = ProductionSpeechService();
      await speechService.speakText('Guten Tag!');
      final spoken = await speechService.listenToMicrophone();
      expect(spoken.isNotEmpty, isTrue);
    });
  });
}
