import 'package:equatable/equatable.dart';

class LearningReplayTurn extends Equatable {
  final int turnIndex;
  final String tutorPrompt;
  final String learnerResponse;
  final String correctedResponse;
  final String grammarNote;
  final double phoneticScore;

  const LearningReplayTurn({
    required this.turnIndex,
    required this.tutorPrompt,
    required this.learnerResponse,
    required this.correctedResponse,
    required this.grammarNote,
    required this.phoneticScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'turnIndex': turnIndex,
      'tutorPrompt': tutorPrompt,
      'learnerResponse': learnerResponse,
      'correctedResponse': correctedResponse,
      'grammarNote': grammarNote,
      'phoneticScore': phoneticScore,
    };
  }

  factory LearningReplayTurn.fromJson(Map<String, dynamic> json) {
    return LearningReplayTurn(
      turnIndex: json['turnIndex'] as int,
      tutorPrompt: json['tutorPrompt'] as String,
      learnerResponse: json['learnerResponse'] as String,
      correctedResponse: json['correctedResponse'] as String,
      grammarNote: json['grammarNote'] as String,
      phoneticScore: (json['phoneticScore'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        turnIndex,
        tutorPrompt,
        learnerResponse,
        correctedResponse,
        grammarNote,
        phoneticScore,
      ];
}

class LearningReplayTranscript extends Equatable {
  final String transcriptId;
  final String sessionId;
  final String scenarioId;
  final DateTime timestamp;
  final List<LearningReplayTurn> turns;
  final int speakingConfidenceBefore;
  final int speakingConfidenceAfter;
  final String evidenceSummary;

  const LearningReplayTranscript({
    required this.transcriptId,
    required this.sessionId,
    required this.scenarioId,
    required this.timestamp,
    required this.turns,
    required this.speakingConfidenceBefore,
    required this.speakingConfidenceAfter,
    required this.evidenceSummary,
  });

  @override
  List<Object?> get props => [
        transcriptId,
        sessionId,
        scenarioId,
        timestamp,
        turns,
        speakingConfidenceBefore,
        speakingConfidenceAfter,
        evidenceSummary,
      ];
}
