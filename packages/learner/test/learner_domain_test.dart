import 'package:test/test.dart';
import 'package:dilang_learner/learner.dart';

void main() {
  group('Learner Domain Tests', () {
    test('1. LearnerKnowledgeGraph tracks node states & aggregate mastery', () {
      final now = DateTime.now();

      final node1 = LearnerNodeState(
        itemKey: 'voc_haus',
        level: MasteryLevel.mastered,
        masteryScore: 0.95,
        lastInteracted: now,
        totalInteractions: 10,
        totalSuccesses: 9,
      );

      final node2 = LearnerNodeState(
        itemKey: 'g_v2',
        level: MasteryLevel.learning,
        masteryScore: 0.45,
        lastInteracted: now,
        totalInteractions: 3,
        totalSuccesses: 2,
      );

      final graph = LearnerKnowledgeGraph(
        learnerId: 'user_001',
        targetLanguage: 'de-DE',
        nodeStates: {
          'voc_haus': node1,
          'g_v2': node2,
        },
      );

      expect(graph.totalTrackedItems, equals(2));
      expect(graph.totalMasteredItems, equals(1));
      expect(graph.overallMasteryRatio, closeTo(0.70, 0.01));
    });
  });
}
