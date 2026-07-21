import 'package:equatable/equatable.dart';

enum ConversationState { idle, active_turn, processing_ai, completed }

class ConversationTurn extends Equatable {
  final String turnId;
  final String speakerRole; // 'user' or 'agent'
  final String text;
  final DateTime timestamp;

  const ConversationTurn({
    required this.turnId,
    required this.speakerRole,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [turnId, speakerRole, text, timestamp];
}

class ConversationSession extends Equatable {
  final String sessionId;
  final String targetLanguage;
  final ConversationState state;
  final List<ConversationTurn> history;

  const ConversationSession({
    required this.sessionId,
    required this.targetLanguage,
    this.state = ConversationState.idle,
    this.history = const [],
  });

  ConversationSession addTurn(ConversationTurn turn) {
    return ConversationSession(
      sessionId: sessionId,
      targetLanguage: targetLanguage,
      state: state,
      history: [...history, turn],
    );
  }

  @override
  List<Object?> get props => [sessionId, targetLanguage, state, history];
}
