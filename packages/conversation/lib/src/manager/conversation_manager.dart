import 'package:dilang_core/core.dart';
import 'package:dilang_ai_runtime/ai_runtime.dart';
import '../session/conversation_session.dart';

class ConversationTurnCompletedEvent extends DomainEvent {
  final String sessionId;
  final String userText;
  final String agentText;

  const ConversationTurnCompletedEvent({
    required super.eventId,
    required super.aggregateId,
    required super.timestamp,
    required super.producerModule,
    required this.sessionId,
    required this.userText,
    required this.agentText,
  });

  @override
  List<Object?> get props => [...super.props, sessionId, userText, agentText];
}

class ConversationManager implements ModuleLifecycle {
  final EventBus eventBus;
  final InferencePipeline pipeline;
  ModuleState _state = ModuleState.uninitialized;

  ConversationManager({
    required this.eventBus,
    required this.pipeline,
  });

  @override
  String get moduleId => 'dilang.conversation.manager';

  @override
  ModuleState get state => _state;

  Future<ConversationSession> processUserTurn({
    required ConversationSession currentSession,
    required String userInput,
    required PromptTemplate promptTemplate,
  }) async {
    final userTurn = ConversationTurn(
      turnId: 'turn_${DateTime.now().millisecondsSinceEpoch}',
      speakerRole: 'user',
      text: userInput,
      timestamp: DateTime.now(),
    );

    var updatedSession = currentSession.addTurn(userTurn);

    // LLM Inference Execution
    final llmOutput = await pipeline.llmProvider.generate(
      template: promptTemplate,
      userInput: userInput,
    );

    final agentText = llmOutput.jsonPayload['response'] as String? ?? '...';
    final agentTurn = ConversationTurn(
      turnId: 'turn_${DateTime.now().millisecondsSinceEpoch + 1}',
      speakerRole: 'agent',
      text: agentText,
      timestamp: DateTime.now(),
    );

    updatedSession = updatedSession.addTurn(agentTurn);

    // Emit Domain Event for Learning Engine to consume asynchronously
    eventBus.publish(
      ConversationTurnCompletedEvent(
        eventId: 'evt_${DateTime.now().millisecondsSinceEpoch}',
        aggregateId: currentSession.sessionId,
        timestamp: DateTime.now(),
        producerModule: moduleId,
        sessionId: currentSession.sessionId,
        userText: userInput,
        agentText: agentText,
      ),
    );

    return updatedSession;
  }

  @override
  Future<void> initialize() async => _state = ModuleState.initialized;

  @override
  Future<void> start() async => _state = ModuleState.running;

  @override
  Future<void> pause() async => _state = ModuleState.paused;

  @override
  Future<void> resume() async => _state = ModuleState.running;

  @override
  Future<void> stop() async => _state = ModuleState.stopped;

  @override
  Future<void> dispose() async => _state = ModuleState.disposed;
}
