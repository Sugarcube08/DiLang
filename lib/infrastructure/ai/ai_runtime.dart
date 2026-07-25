import 'model_registry/model_descriptor.dart';
import 'model_registry/model_registry.dart';
import 'prompting/prompt_pipeline.dart';
import 'providers/ai_provider.dart';
import 'ai_session.dart';

class AiRuntime {
  AiProvider _activeProvider;
  ModelDescriptor _activeModel;
  final PromptPipeline promptPipeline;

  AiSessionStatus _status = AiSessionStatus.idle;
  int _lastResponseLatencyMs = 0;

  AiRuntime({
    AiProvider? activeProvider,
    ModelDescriptor? activeModel,
    PromptPipeline? pipeline,
  })  : _activeProvider = activeProvider ?? NoOpAiProvider(),
        _activeModel = activeModel ?? ModelRegistry.defaultModel,
        promptPipeline = pipeline ?? PromptPipeline();

  AiProvider get activeProvider => _activeProvider;
  ModelDescriptor get activeModel => _activeModel;
  AiSessionStatus get status => _status;
  int get lastResponseLatencyMs => _lastResponseLatencyMs;

  void setProvider(AiProvider provider) {
    _activeProvider = provider;
  }

  void setModel(String modelId) {
    _activeModel = ModelRegistry.findById(modelId);
  }

  Future<void> initialize() async {
    await _activeProvider.initialize();
  }

  Future<String> executeInference({
    required String systemPrompt,
    required String userInput,
    String identityContext = '',
    String learningContext = '',
    String conversationContext = '',
    String knowledgeGraphContext = '',
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    _status = AiSessionStatus.runningInference;
    final stopwatch = Stopwatch()..start();

    try {
      final promptContext = await promptPipeline.assemble(
        systemPrompt: systemPrompt,
        userInput: userInput,
        identityContext: identityContext,
        learningContext: learningContext,
        conversationContext: conversationContext,
        knowledgeGraphContext: knowledgeGraphContext,
      );

      final response = await _activeProvider.generateInference(
        context: promptContext,
        modelId: _activeModel.id,
        temperature: temperature,
        maxTokens: maxTokens,
      );

      stopwatch.stop();
      _lastResponseLatencyMs = stopwatch.elapsedMilliseconds;
      _status = AiSessionStatus.completed;
      return response;
    } catch (e) {
      stopwatch.stop();
      _status = AiSessionStatus.failed;
      rethrow;
    }
  }

  Stream<String> streamInference({
    required String systemPrompt,
    required String userInput,
    String identityContext = '',
    String learningContext = '',
    String conversationContext = '',
    String knowledgeGraphContext = '',
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async* {
    _status = AiSessionStatus.streaming;
    final stopwatch = Stopwatch()..start();

    final promptContext = await promptPipeline.assemble(
      systemPrompt: systemPrompt,
      userInput: userInput,
      identityContext: identityContext,
      learningContext: learningContext,
      conversationContext: conversationContext,
      knowledgeGraphContext: knowledgeGraphContext,
    );

    yield* _activeProvider.streamInference(
      context: promptContext,
      modelId: _activeModel.id,
      temperature: temperature,
      maxTokens: maxTokens,
    );

    stopwatch.stop();
    _lastResponseLatencyMs = stopwatch.elapsedMilliseconds;
    _status = AiSessionStatus.completed;
  }

  Future<void> dispose() async {
    await _activeProvider.dispose();
  }
}
