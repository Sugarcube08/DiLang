import 'package:equatable/equatable.dart';

class LanguageHealthMetrics extends Equatable {
  final double vocabularyHealth;   // e.g. 0.84
  final double grammarHealth;      // e.g. 0.89
  final double speakingHealth;     // e.g. 0.73
  final double listeningHealth;    // e.g. 0.81
  final double readingHealth;      // e.g. 0.95
  final double writingHealth;      // e.g. 0.69
  final double conversationHealth; // e.g. 0.78
  final double memoryHealth;       // e.g. 0.93

  const LanguageHealthMetrics({
    this.vocabularyHealth = 0.84,
    this.grammarHealth = 0.89,
    this.speakingHealth = 0.73,
    this.listeningHealth = 0.81,
    this.readingHealth = 0.95,
    this.writingHealth = 0.69,
    this.conversationHealth = 0.78,
    this.memoryHealth = 0.93,
  });

  double calculateOverallHealth() {
    return (vocabularyHealth +
            grammarHealth +
            speakingHealth +
            listeningHealth +
            readingHealth +
            writingHealth +
            conversationHealth +
            memoryHealth) /
        8.0;
  }

  @override
  List<Object?> get props => [
        vocabularyHealth,
        grammarHealth,
        speakingHealth,
        listeningHealth,
        readingHealth,
        writingHealth,
        conversationHealth,
        memoryHealth,
      ];
}
