import '../native_bridge.dart';

abstract class ConversationRepository {
  Future<String> startConversation(String scenarioId);
  Future<String> reply(String conversationId, String text);
}

class ConversationRepositoryImpl implements ConversationRepository {
  @override
  Future<String> startConversation(String scenarioId) async {
    return 'conv-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<String> reply(String conversationId, String text) async {
    return DiLangNativeBridge.ping();
  }
}
