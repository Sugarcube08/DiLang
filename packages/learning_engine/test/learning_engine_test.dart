import 'package:test/test.dart';
import 'package:dilang_learner/learner.dart';
import 'package:dilang_memory/memory.dart';
import 'package:dilang_language/language.dart';
import 'package:dilang_learning_engine/learning_engine.dart';

void main() {
  group('Learning Engine & Assessment Platform Tests', () {
    final now = DateTime(2026, 7, 22, 12, 0);

    test('1. RecommendationEngine evaluates retrievability decay against versioned LearningPolicy', () {
      final orchestrator = LearningEngineOrchestrator(
        policy: const LearningPolicy(targetRetentionThreshold: 0.90),
        recommendationEngine: const RecommendationEngine(),
      );

      const graph = LearnerKnowledgeGraph(
        learnerId: 'user_100',
        targetLanguage: 'de-DE',
      );

      final fsrsOverdue = FsrsItemState(
        stability: 3.0,
        difficulty: 5.0,
        reps: 2,
        lapses: 0,
        lastReviewed: now.subtract(const Duration(days: 5)),
        due: now.subtract(const Duration(days: 2)),
      );

      final recs = orchestrator.evaluateNextSession(
        graph: graph,
        fsrsStates: {'voc_haus': fsrsOverdue},
        currentTimestamp: now,
      );

      expect(recs.length, equals(1));
      expect(recs.first.itemKey, equals('voc_haus'));
      expect(recs.first.action, equals(LearningAction.review_fsrs));
      expect(recs.first.diagnostic.predictedRetrievability, lessThan(0.90));
      expect(recs.first.diagnostic.reasoning, contains('threshold'));
    });

    test('2. CurriculumGraph evaluates prerequisite DAG constraints', () {
      const objNouns = LearningObjective(
        id: 'obj_nouns',
        title: 'Basic Nouns',
        description: 'Learn A1 nouns',
        cefrLevel: CefrLevel.a1,
      );

      const objV2 = LearningObjective(
        id: 'obj_v2',
        title: 'Verb-Second Order',
        description: 'Learn German V2 syntax',
        cefrLevel: CefrLevel.a1,
        prerequisiteObjectiveIds: ['obj_nouns'],
      );

      const graph = CurriculumGraph(
        languageCode: 'de-DE',
        objectives: {
          'obj_nouns': objNouns,
          'obj_v2': objV2,
        },
      );

      expect(graph.isUnlocked('obj_v2', {}), isFalse);
      expect(graph.isUnlocked('obj_v2', {'obj_nouns'}), isTrue);
    });

    test('3. Multimodal Assessment Engine aggregates evidence across modalities', () {
      const assessment = AssessmentEngine();

      const evidence = MultimodalEvidence(
        vocabularyScore: 0.90,
        grammarScore: 0.85,
        pronunciationScore: 0.88,
        listeningScore: 0.80,
        writingScore: 0.82,
        readingScore: 0.92,
        conversationScore: 0.75,
      );

      final overallCompetence = assessment.evaluateCompetence(evidence);
      expect(overallCompetence, closeTo(0.85, 0.05));
    });

    test('4. ProgressionModel evaluates evidence for CEFR promotion', () {
      const progression = ProgressionModel();
      const policy = LearningPolicy(cefrPromotionThreshold: 0.85);

      const highEvidence = MultimodalEvidence(
        vocabularyScore: 0.90,
        grammarScore: 0.90,
        pronunciationScore: 0.90,
        listeningScore: 0.90,
        writingScore: 0.90,
        readingScore: 0.90,
        conversationScore: 0.90,
      );

      final canPromote = progression.canPromoteToNextCefr(
        currentLevel: CefrLevel.a1,
        aggregateEvidence: highEvidence,
        policy: policy,
      );

      expect(canPromote, isTrue);
    });
  });
}
