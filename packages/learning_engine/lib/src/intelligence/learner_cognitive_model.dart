import 'package:equatable/equatable.dart';

class LearnerCognitiveModel extends Equatable {
  final String userId;
  final double vocabularyMastery; // 0.0 - 1.0
  final double grammarMastery;
  final double pronunciationConfidence;
  final double listeningComprehension;
  final double readingFluency;
  final double writingFluency;
  final double recallStability;
  final double cognitiveLoadIndex;
  final double learningVelocity;
  final double estimatedCefrReadiness; // e.g. 0.82

  const LearnerCognitiveModel({
    required this.userId,
    required this.vocabularyMastery,
    required this.grammarMastery,
    required this.pronunciationConfidence,
    required this.listeningComprehension,
    required this.readingFluency,
    required this.writingFluency,
    required this.recallStability,
    required this.cognitiveLoadIndex,
    required this.learningVelocity,
    required this.estimatedCefrReadiness,
  });

  @override
  List<Object?> get props => [
        userId,
        vocabularyMastery,
        grammarMastery,
        pronunciationConfidence,
        listeningComprehension,
        readingFluency,
        writingFluency,
        recallStability,
        cognitiveLoadIndex,
        learningVelocity,
        estimatedCefrReadiness,
      ];
}

class ErrorCauseAnalysis extends Equatable {
  final String errorId;
  final String userId;
  final String mistakeText;
  final String errorCategory;
  final String underlyingCause;
  final int totalOccurrences;
  final int totalRecoveries;
  final String recommendedIntervention;

  const ErrorCauseAnalysis({
    required this.errorId,
    required this.userId,
    required this.mistakeText,
    required this.errorCategory,
    required this.underlyingCause,
    required this.totalOccurrences,
    required this.totalRecoveries,
    required this.recommendedIntervention,
  });

  @override
  List<Object?> get props => [
        errorId,
        userId,
        mistakeText,
        errorCategory,
        underlyingCause,
        totalOccurrences,
        totalRecoveries,
        recommendedIntervention,
      ];
}

class ExplainableMissionRecommendation extends Equatable {
  final String missionTitle;
  final String suggestedAction;
  final List<String> explicitReasons;
  final List<String> predictedHighDecayItems;

  const ExplainableMissionRecommendation({
    required this.missionTitle,
    required this.suggestedAction,
    required this.explicitReasons,
    required this.predictedHighDecayItems,
  });

  @override
  List<Object?> get props => [
        missionTitle,
        suggestedAction,
        explicitReasons,
        predictedHighDecayItems,
      ];
}
