import '../model_registry/ai_provider_capabilities.dart';
import '../prompting/prompt_context.dart';

abstract class AiProvider {
  String get name;
  AiProviderCapabilities get capabilities;

  Future<void> initialize();
  
  Future<String> generateInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  });

  Stream<String> streamInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  });

  Future<void> dispose();
}

class GeminiAiProvider implements AiProvider {
  @override
  String get name => 'Gemini';

  @override
  AiProviderCapabilities get capabilities => const AiProviderCapabilities(
        supportsStreaming: true,
        supportsImages: true,
        supportsAudio: true,
        supportsJsonOutput: true,
        supportsToolCalling: true,
      );

  @override
  Future<void> initialize() async {}

  @override
  Future<String> generateInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    return 'Gemini Inference Response for: ${context.userInput}';
  }

  @override
  Stream<String> streamInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async* {
    yield 'Gemini ';
    yield 'streamed ';
    yield 'response.';
  }

  @override
  Future<void> dispose() async {}
}

class LocalLlamaAiProvider implements AiProvider {
  @override
  String get name => 'Local (llama.cpp)';

  @override
  AiProviderCapabilities get capabilities => const AiProviderCapabilities(
        supportsStreaming: true,
        supportsJsonOutput: true,
      );

  @override
  Future<void> initialize() async {}

  @override
  Future<String> generateInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    return 'Local llama.cpp response for: ${context.userInput}';
  }

  @override
  Stream<String> streamInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async* {
    yield 'Local ';
    yield 'llama.cpp ';
    yield 'tokens.';
  }

  @override
  Future<void> dispose() async {}
}

class NoOpAiProvider implements AiProvider {
  @override
  String get name => 'NoOp (Not Configured)';

  @override
  AiProviderCapabilities get capabilities => const AiProviderCapabilities.basic();

  @override
  Future<void> initialize() async {}

  @override
  Future<String> generateInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    return 'AI Provider not configured.';
  }

  @override
  Stream<String> streamInference({
    required PromptContext context,
    required String modelId,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async* {
    yield 'AI Provider not configured.';
  }

  @override
  Future<void> dispose() async {}
}
