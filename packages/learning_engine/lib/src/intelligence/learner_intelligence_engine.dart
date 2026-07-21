import 'learner_cognitive_model.dart';

class LearnerIntelligenceEngine {
  const LearnerIntelligenceEngine();

  LearnerCognitiveModel inferCognitiveModel({
    required String userId,
    required int totalSessions,
    required double averageAccuracy,
    required int dueReviewsCount,
  }) {
    final vocabMastery = (averageAccuracy * 0.95).clamp(0.4, 0.98);
    final grammarMastery = (averageAccuracy * 0.90).clamp(0.35, 0.95);
    final recall = (1.0 - (dueReviewsCount / 100.0)).clamp(0.5, 0.95);
    final cefrProgress = (totalSessions * 0.05).clamp(0.1, 0.95);

    return LearnerCognitiveModel(
      userId: userId,
      vocabularyMastery: vocabMastery,
      grammarMastery: grammarMastery,
      pronunciationConfidence: averageAccuracy * 0.92,
      listeningComprehension: averageAccuracy * 0.88,
      readingFluency: averageAccuracy * 0.94,
      writingFluency: averageAccuracy * 0.85,
      recallStability: recall,
      cognitiveLoadIndex: 0.35,
      learningVelocity: 1.2,
      estimatedCefrReadiness: cefrProgress,
    );
  }

  ErrorCauseAnalysis analyzeError({
    required String userId,
    required String mistakeText,
    required int occurrences,
    required int recoveries,
  }) {
    String category = 'Grammar';
    String underlyingCause = 'Accusative masculine article inflection';
    String intervention = 'Contextual Viennese café dialogue reinforcement';

    if (mistakeText.contains('Bahnhof') || mistakeText.contains('Kaffee')) {
      category = 'Vocabulary';
      underlyingCause = 'Noun gender memory decay (der vs die vs das)';
      intervention = 'Spaced repetition review sweep of high-decay items';
    }

    return ErrorCauseAnalysis(
      errorId: 'err_${mistakeText.hashCode}',
      userId: userId,
      mistakeText: mistakeText,
      errorCategory: category,
      underlyingCause: underlyingCause,
      totalOccurrences: occurrences,
      totalRecoveries: recoveries,
      recommendedIntervention: intervention,
    );
  }

  ExplainableMissionRecommendation generateExplainableRecommendation({
    required LearnerCognitiveModel model,
    required ErrorCauseAnalysis primaryError,
  }) {
    final reasons = [
      'Vocabulary retention is at ${(model.vocabularyMastery * 100).round()}%',
      'Underlying cause identified: ${primaryError.underlyingCause}',
      'Estimated CEFR A1 readiness: ${(model.estimatedCefrReadiness * 100).round()}%',
      'Speaking confidence is improving steadily',
    ];

    return ExplainableMissionRecommendation(
      missionTitle: 'Ordering at a Viennese Café',
      suggestedAction: primaryError.recommendedIntervention,
      explicitReasons: reasons,
      predictedHighDecayItems: const ['Bahnhof', 'Bestellung', 'einen'],
    );
  }
}
