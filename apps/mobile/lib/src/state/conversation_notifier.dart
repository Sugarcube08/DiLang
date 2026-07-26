import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/conversation_repository.dart';

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepositoryImpl();
});

class ConversationState {
  final String? activeConversationId;
  final List<String> messages;
  final bool isLoading;

  const ConversationState({
    this.activeConversationId,
    this.messages = const [],
    this.isLoading = false,
  });

  ConversationState copyWith({
    String? activeConversationId,
    List<String>? messages,
    bool? isLoading,
  }) {
    return ConversationState(
      activeConversationId: activeConversationId ?? this.activeConversationId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ConversationNotifier extends StateNotifier<ConversationState> {
  final ConversationRepository _repository;

  ConversationNotifier(this._repository) : super(const ConversationState());

  Future<void> startSession(String scenarioId) async {
    state = state.copyWith(isLoading: true);
    final convId = await _repository.startConversation(scenarioId);
    state = state.copyWith(activeConversationId: convId, isLoading: false);
  }

  Future<void> sendMessage(String text) async {
    if (state.activeConversationId == null) return;
    final updatedMessages = [...state.messages, 'User: $text'];
    state = state.copyWith(messages: updatedMessages, isLoading: true);

    final replyText = await _repository.reply(state.activeConversationId!, text);
    state = state.copyWith(
      messages: [...updatedMessages, 'AI: $replyText'],
      isLoading: false,
    );
  }
}

final conversationProvider = StateNotifierProvider<ConversationNotifier, ConversationState>((ref) {
  final repo = ref.watch(conversationRepositoryProvider);
  return ConversationNotifier(repo);
});
