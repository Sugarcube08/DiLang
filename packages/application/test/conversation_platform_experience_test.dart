import 'package:test/test.dart';
import 'package:dilang_storage/storage.dart';
import 'package:dilang_conversation/conversation.dart';

void main() {
  group('Conversation Platform & Three Quality Gates Tests', () {
    late SqliteStorageEngine storageEngine;
    late SqliteReplayRepository replayRepo;

    setUp(() {
      storageEngine = SqliteStorageEngine.inMemory();
      replayRepo = SqliteReplayRepository(engine: storageEngine);
    });

    tearDown(() {
      storageEngine.dispose();
    });

    test('1. Pedagogy Gate: DialogueManager generates pre-session briefing & post-session evidence', () {
      final scenario = BuiltInScenarios.ScenarioCafeVienna;
      final manager = DialogueManager(scenario: scenario);

      // Pre-Session Briefing
      final briefing = manager.generatePreSessionBriefing();
      expect(briefing.preSessionCoaching, contains('Watch for adjective endings'));
      expect(briefing.culturalTip, contains('Einen Verlängerten'));

      // Execute Turns
      manager.processTurn(
        tutorPrompt: 'Grüß Gott! Was darf ich Ihnen bringen?',
        learnerResponse: 'Ich möchte einen heiße Kaffee, bitte.',
        correctedResponse: 'Ich möchte einen heißen Kaffee, bitte.',
        grammarNote: 'Masculine accusative requires weak adjective ending -en.',
        phoneticScore: 0.92,
      );

      manager.processTurn(
        tutorPrompt: 'Sehr gerne. Und zu essen?',
        learnerResponse: 'Ein Stück Sachertorte, bitte.',
        correctedResponse: 'Ein Stück Sachertorte, bitte.',
        grammarNote: 'Perfect nominative neuter usage.',
        phoneticScore: 0.98,
      );

      // Post-Session Debriefing
      final debriefing = manager.generatePostSessionDebriefing(initialConfidence: 72);
      expect(debriefing.speakingConfidenceBefore, equals(72));
      expect(debriefing.speakingConfidenceAfter, equals(77)); // 72 + 5
      expect(debriefing.totalTurnsCompleted, equals(2));
      expect(debriefing.evidenceSummary, contains('Speaking Confidence 72 ➔ 77'));
    });

    test('2. Engineering Gate: LearningReplayTranscript persisted to & retrieved from SQLite with 100% fidelity', () async {
      final scenario = BuiltInScenarios.ScenarioDoctorAppointment;
      final manager = DialogueManager(scenario: scenario);

      final turn1 = manager.processTurn(
        tutorPrompt: 'Guten Tag, wie kann ich Ihnen helfen?',
        learnerResponse: 'Ich habe seit zwei Tagen starke Kopfschmerzen.',
        correctedResponse: 'Ich habe seit zwei Tagen starke Kopfschmerzen.',
        grammarNote: 'Flawless dative plural preposition usage (seit zwei Tagen).',
        phoneticScore: 0.95,
      );

      final debriefing = manager.generatePostSessionDebriefing(initialConfidence: 75);

      final transcript = LearningReplayTranscript(
        transcriptId: 'tr_doc_001',
        sessionId: 'sess_doc_001',
        scenarioId: scenario.id,
        timestamp: DateTime.utc(2026, 7, 22),
        turns: [turn1],
        speakingConfidenceBefore: debriefing.speakingConfidenceBefore,
        speakingConfidenceAfter: debriefing.speakingConfidenceAfter,
        evidenceSummary: debriefing.evidenceSummary,
      );

      await replayRepo.saveTranscript(transcript);

      final retrieved = await replayRepo.getTranscript('tr_doc_001');
      expect(retrieved, isNotNull);
      expect(retrieved!.sessionId, equals('sess_doc_001'));
      expect(retrieved.speakingConfidenceBefore, equals(75));
      expect(retrieved.speakingConfidenceAfter, equals(85));
      expect(retrieved.turns.length, equals(1));
      expect(retrieved.turns.first.learnerResponse, equals('Ich habe seit zwei Tagen starke Kopfschmerzen.'));
      expect(retrieved.turns.first.grammarNote, contains('dative plural'));
    });

    test('3. AI Quality Gate: Scenario constraints enforce persona & level-appropriate grammar targets', () {
      final scenario = BuiltInScenarios.ScenarioCafeVienna;
      expect(scenario.cefrLevel, equals('A1'));
      expect(scenario.personaName, equals('Greta'));
      expect(scenario.targetGrammarRules, contains('accusative_masculine_article'));
      expect(scenario.targetVocabulary, contains('der Kaffee'));
    });
  });
}
