import 'llm_provider.dart';

class NoOpLlmProvider implements LlmProvider {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<LlmResponse> generateResponse({
    required String systemPrompt,
    required String userInput,
    Map<String, dynamic> context = const {},
  }) async {
    return const LlmResponse(text: 'LLM Provider not configured.');
  }

  @override
  Stream<String> streamResponse({
    required String systemPrompt,
    required String userInput,
  }) async* {
    yield 'LLM Provider not configured.';
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
  }
}
