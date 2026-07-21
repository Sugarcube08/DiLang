import 'package:test/test.dart';
import 'package:dilang_core/core.dart';
import 'package:dilang_ai_runtime/ai_runtime.dart';
import 'package:dilang_conversation/conversation.dart';

class MockLlmProvider implements LlmProvider {
  @override
  Future<void> loadModel(String modelPath) async {}

  @override
  Future<StructuredOutput> generate({
    required PromptTemplate template,
    required String userInput,
  }) async {
    return const StructuredOutput(
      rawText: '{"response": "Gut, danke!"}',
      jsonPayload: {'response': 'Gut, danke!'},
      isValidJson: true,
    );
  }

  @override
  Stream<String> generateStream({
    required PromptTemplate template,
    required String userInput,
  }) async* {
    yield 'Gut, danke!';
  }

  @override
  Future<void> unloadModel() async {}
}

void main() {
  group('Conversation Engine Tests', () {
    test('1. ConversationManager executes turn, updates history, and emits domain event', () async {
      final eventBus = EventBus();
      DomainEvent? receivedEvent;

      eventBus.subscribe<ConversationTurnCompletedEvent>((event) {
        receivedEvent = event;
      });

      final pipeline = InferencePipeline(llmProvider: MockLlmProvider());
      final manager = ConversationManager(eventBus: eventBus, pipeline: pipeline);

      const session = ConversationSession(
        sessionId: 'sess_100',
        targetLanguage: 'de-DE',
      );

      const template = PromptTemplate(systemRole: 'Tutor');

      final updatedSession = await manager.processUserTurn(
        currentSession: session,
        userInput: 'Wie gehts?',
        promptTemplate: template,
      );

      expect(updatedSession.history.length, equals(2));
      expect(updatedSession.history[0].text, equals('Wie gehts?'));
      expect(updatedSession.history[1].text, equals('Gut, danke!'));

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(receivedEvent, isA<ConversationTurnCompletedEvent>());

      await eventBus.dispose();
    });
  });
}
