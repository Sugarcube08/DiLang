import 'package:equatable/equatable.dart';

class MultimodalEvidence extends Equatable {
  final double vocabularyScore;
  final double grammarScore;
  final double pronunciationScore;
  final double listeningScore;
  final double writingScore;
  final double readingScore;
  final double conversationScore;

  const MultimodalEvidence({
    required this.vocabularyScore,
    required this.grammarScore,
    required this.pronunciationScore,
    required this.listeningScore,
    required this.writingScore,
    required this.readingScore,
    required this.conversationScore,
  });

  double calculateAggregateScore() {
    return vocabularyScore * 0.20 +
        grammarScore * 0.20 +
        pronunciationScore * 0.15 +
        listeningScore * 0.15 +
        writingScore * 0.10 +
        readingScore * 0.10 +
        conversationScore * 0.10;
  }

  @override
  List<Object?> get props => [
        vocabularyScore,
        grammarScore,
        pronunciationScore,
        listeningScore,
        writingScore,
        readingScore,
        conversationScore,
      ];
}

class AssessmentEngine {
  const AssessmentEngine();

  double evaluateCompetence(MultimodalEvidence evidence) {
    return evidence.calculateAggregateScore();
  }
}
