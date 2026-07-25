import 'package:equatable/equatable.dart';

class PromptContext extends Equatable {
  final String systemPrompt;
  final String identityContext;
  final String learningContext;
  final String conversationContext;
  final String knowledgeGraphContext;
  final String userInput;

  const PromptContext({
    required this.systemPrompt,
    this.identityContext = '',
    this.learningContext = '',
    this.conversationContext = '',
    this.knowledgeGraphContext = '',
    required this.userInput,
  });

  String assembleFullPrompt() {
    final buf = StringBuffer();
    buf.writeln('=== SYSTEM INSTRUCTIONS ===');
    buf.writeln(systemPrompt);
    buf.writeln();

    if (identityContext.isNotEmpty) {
      buf.writeln('=== LEARNER IDENTITY CONTEXT ===');
      buf.writeln(identityContext);
      buf.writeln();
    }

    if (learningContext.isNotEmpty) {
      buf.writeln('=== LEARNING & FSRS CONTEXT ===');
      buf.writeln(learningContext);
      buf.writeln();
    }

    if (knowledgeGraphContext.isNotEmpty) {
      buf.writeln('=== KNOWLEDGE GRAPH CONTEXT ===');
      buf.writeln(knowledgeGraphContext);
      buf.writeln();
    }

    if (conversationContext.isNotEmpty) {
      buf.writeln('=== RECENT DIALOGUE HISTORY ===');
      buf.writeln(conversationContext);
      buf.writeln();
    }

    buf.writeln('=== USER INPUT ===');
    buf.writeln(userInput);

    return buf.toString();
  }

  @override
  List<Object?> get props => [
        systemPrompt,
        identityContext,
        learningContext,
        conversationContext,
        knowledgeGraphContext,
        userInput,
      ];
}
