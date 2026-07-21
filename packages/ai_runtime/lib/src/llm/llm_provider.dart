import 'structured_output.dart';
import 'prompt_builder.dart';

abstract class LlmProvider {
  Future<void> loadModel(String modelPath);
  
  Future<StructuredOutput> generate({
    required PromptTemplate template,
    required String userInput,
  });

  Stream<String> generateStream({
    required PromptTemplate template,
    required String userInput,
  });

  Future<void> unloadModel();
}
