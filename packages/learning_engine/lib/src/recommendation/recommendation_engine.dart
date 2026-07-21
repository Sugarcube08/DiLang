import 'package:equatable/equatable.dart';
import 'package:dilang_learner/learner.dart';
import 'package:dilang_memory/memory.dart';
import '../policies/learning_policy.dart';
import '../diagnostics/recommendation_diagnostic.dart';

enum LearningAction { review_fsrs, introduce_new, practice_conversation }

class LearningRecommendation extends Equatable {
  final String itemKey;
  final LearningAction action;
  final double priorityScore;
  final RecommendationDiagnostic diagnostic;

  const LearningRecommendation({
    required this.itemKey,
    required this.action,
    required this.priorityScore,
    required this.diagnostic,
  });

  @override
  List<Object?> get props => [itemKey, action, priorityScore, diagnostic];
}

class RecommendationEngine {
  final MemoryEngine memoryEngine;

  const RecommendationEngine({this.memoryEngine = const MemoryEngine()});

  List<LearningRecommendation> generateRecommendations({
    required LearnerKnowledgeGraph graph,
    required Map<String, FsrsItemState> fsrsStates,
    required LearningPolicy policy,
    required DateTime currentTimestamp,
  }) {
    final recommendations = <LearningRecommendation>[];

    for (final entry in fsrsStates.entries) {
      final itemKey = entry.key;
      final fsrsState = entry.value;

      final retrievability = memoryEngine.predictRetrievability(
        state: fsrsState,
        currentTimestamp: currentTimestamp,
      );

      if (retrievability < policy.targetRetentionThreshold) {
        final daysOverdue = currentTimestamp.difference(fsrsState.due).inHours / 24.0;
        final priority = 10.0 + (policy.targetRetentionThreshold - retrievability) * 10.0 + daysOverdue;

        recommendations.add(
          LearningRecommendation(
            itemKey: itemKey,
            action: LearningAction.review_fsrs,
            priorityScore: priority,
            diagnostic: RecommendationDiagnostic(
              predictedRetrievability: retrievability,
              targetRetention: policy.targetRetentionThreshold,
              daysOverdue: daysOverdue,
              reasoning: 'Retrievability ($retrievability) fell below target threshold (${policy.targetRetentionThreshold}).',
            ),
          ),
        );
      }
    }

    recommendations.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    return recommendations;
  }
}
