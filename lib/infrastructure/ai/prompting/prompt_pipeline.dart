import 'prompt_context.dart';

abstract class ContextContributor {
  Future<String> contributeContext();
}

class PromptPipeline {
  final List<ContextContributor> contributors;

  PromptPipeline({this.contributors = const []});

  Future<PromptContext> assemble({
    required String systemPrompt,
    required String userInput,
    String identityContext = '',
    String learningContext = '',
    String conversationContext = '',
    String knowledgeGraphContext = '',
  }) async {
    return PromptContext(
      systemPrompt: systemPrompt,
      identityContext: identityContext,
      learningContext: learningContext,
      conversationContext: conversationContext,
      knowledgeGraphContext: knowledgeGraphContext,
      userInput: userInput,
    );
  }
}
