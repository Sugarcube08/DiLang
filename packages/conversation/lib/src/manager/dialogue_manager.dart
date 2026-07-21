import '../scenarios/conversation_scenario.dart';
import '../replay/learning_replay_transcript.dart';

class SessionBriefing {
  final String preSessionCoaching;
  final String targetGrammarFocus;
  final String culturalTip;

  const SessionBriefing({
    required this.preSessionCoaching,
    required this.targetGrammarFocus,
    required this.culturalTip,
  });
}

class SessionDebriefing {
  final int speakingConfidenceBefore;
  final int speakingConfidenceAfter;
  final int totalTurnsCompleted;
  final double grammarAccuracyRatio;
  final String evidenceSummary;
  final String postSessionCoaching;

  const SessionDebriefing({
    required this.speakingConfidenceBefore,
    required this.speakingConfidenceAfter,
    required this.totalTurnsCompleted,
    required this.grammarAccuracyRatio,
    required this.evidenceSummary,
    required this.postSessionCoaching,
  });
}

class DialogueManager {
  final ConversationScenario scenario;
  final List<LearningReplayTurn> _turns = [];
  int _currentTurnIndex = 0;

  DialogueManager({required this.scenario});

  List<LearningReplayTurn> get turns => List.unmodifiable(_turns);

  SessionBriefing generatePreSessionBriefing() {
    final focus = scenario.targetGrammarRules.isNotEmpty ? scenario.targetGrammarRules.first : 'Vocabulary';
    return SessionBriefing(
      preSessionCoaching: 'Watch for adjective endings after accusative articles. You will encounter them frequently during this dialogue.',
      targetGrammarFocus: focus,
      culturalTip: scenario.culturalNote,
    );
  }

  LearningReplayTurn processTurn({
    required String tutorPrompt,
    required String learnerResponse,
    required String correctedResponse,
    required String grammarNote,
    required double phoneticScore,
  }) {
    _currentTurnIndex++;
    final turn = LearningReplayTurn(
      turnIndex: _currentTurnIndex,
      tutorPrompt: tutorPrompt,
      learnerResponse: learnerResponse,
      correctedResponse: correctedResponse,
      grammarNote: grammarNote,
      phoneticScore: phoneticScore,
    );
    _turns.add(turn);
    return turn;
  }

  SessionDebriefing generatePostSessionDebriefing({required int initialConfidence}) {
    final totalTurns = _turns.length;
    final validTurns = _turns.where((t) => t.learnerResponse == t.correctedResponse).length;
    final ratio = totalTurns > 0 ? validTurns / totalTurns : 1.0;

    final gain = (ratio * 10).round();
    final finalConfidence = (initialConfidence + gain).clamp(0, 100);

    final summary = 'Speaking Confidence $initialConfidence ➔ $finalConfidence (+$gain pts). $totalTurns successful turns executed with ${ (ratio * 100).round() }% grammar accuracy.';

    final postCoaching = ratio >= 0.8
        ? 'Great improvement! Your accusative article usage was crisp and accurate.'
        : 'Good effort! We will reinforce accusative food ordering again tomorrow.';

    return SessionDebriefing(
      speakingConfidenceBefore: initialConfidence,
      speakingConfidenceAfter: finalConfidence,
      totalTurnsCompleted: totalTurns,
      grammarAccuracyRatio: ratio,
      evidenceSummary: summary,
      postSessionCoaching: postCoaching,
    );
  }
}
