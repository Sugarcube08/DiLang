import 'dart:io';
import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_application/application.dart';
import 'package:dilang_conversation/conversation.dart';

void main() {
  late String dbPath;

  setUp(() {
    final tempDir = Directory.systemTemp.createTempSync('dilang_ai_test_');
    dbPath = '${tempDir.path}/dilang_storage.db';
  });

  tearDown(() {
    final file = File(dbPath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Phase 2 — AI Runtime & Conversation Intelligence Verification', () {
    test('LLM Provider Abstraction & Adaptive Prompt Assembly', () async {
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
        name: 'AI_Learner',
        mediumLanguage: 'English',
        targetLanguage: 'German',
        brainModel: 'Conversation First',
        learningGoal: 'Daily Conversation',
        aiCoachPersona: 'Friendly',
      );

      final scenario = BuiltInScenarios.ScenarioCafeVienna;
      final assembler = const AdaptivePromptAssembler();
      final prompt = assembler.assembleSystemPrompt(
        learner: kernel.state.learner!,
        scenario: scenario,
        weakGrammarNodes: ['node_art_der'],
      );

      expect(prompt, contains('Target Language: German'));
      expect(prompt, contains('Learner CEFR Level: A1'));
      expect(prompt, contains('Learner Weak Grammar Points to target: node_art_der'));

      engine.dispose();
    });

    test('ConversationRuntime processes turn & generates AI tutor completion', () async {
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
        name: 'Turn_Learner',
        mediumLanguage: 'English',
        targetLanguage: 'German',
        brainModel: 'Conversation First',
        learningGoal: 'Daily Conversation',
        aiCoachPersona: 'Friendly',
      );

      kernel.startSession(BuiltInScenarios.ScenarioCafeVienna);
      await kernel.submitTurn('Ich möchte einen heißen Kaffee, bitte.');

      expect(kernel.state.activeTurns.length, equals(1));
      expect(kernel.state.activeTurns.first.learnerResponse, equals('Ich möchte einen heißen Kaffee, bitte.'));
      expect(kernel.state.activeTurns.first.tutorPrompt, contains('Kaffee'));

      await kernel.completeSession();
      expect(kernel.state.completedSessionsCount, equals(1));

      engine.dispose();
    });
  });
}
