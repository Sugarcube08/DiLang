import 'package:dilang_language/language.dart';
import '../assessment/assessment_engine.dart';
import '../policies/learning_policy.dart';

class ProgressionModel {
  const ProgressionModel();

  bool canPromoteToNextCefr({
    required CefrLevel currentLevel,
    required MultimodalEvidence aggregateEvidence,
    required LearningPolicy policy,
  }) {
    final score = aggregateEvidence.calculateAggregateScore();
    return score >= policy.cefrPromotionThreshold;
  }
}
