import 'package:equatable/equatable.dart';

class PromptSection extends Equatable {
  final String title;
  final String content;

  const PromptSection({required this.title, required this.content});

  @override
  List<Object?> get props => [title, content];
}

class PromptTemplate {
  final String systemRole;
  final List<PromptSection> sections;

  const PromptTemplate({
    required this.systemRole,
    this.sections = const [],
  });

  String buildPrompt(String userInput) {
    final buffer = StringBuffer();
    buffer.writeln('<SYSTEM>');
    buffer.writeln(systemRole);
    buffer.writeln('</SYSTEM>');

    for (final section in sections) {
      buffer.writeln('<${section.title.toUpperCase()}>');
      buffer.writeln(section.content);
      buffer.writeln('</${section.title.toUpperCase()}>');
    }

    buffer.writeln('<USER>');
    buffer.writeln(userInput);
    buffer.writeln('</USER>');

    return buffer.toString();
  }
}
