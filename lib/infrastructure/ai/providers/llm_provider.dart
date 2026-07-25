class LlmResponse {
  final String text;
  final Map<String, dynamic> metadata;

  const LlmResponse({required this.text, this.metadata = const {}});
}

abstract class LlmProvider {
  Future<void> initialize();
  Future<LlmResponse> generateResponse({
    required String systemPrompt,
    required String userInput,
    Map<String, dynamic> context = const {},
  });
  Stream<String> streamResponse({
    required String systemPrompt,
    required String userInput,
  });
  Future<void> dispose();
}
