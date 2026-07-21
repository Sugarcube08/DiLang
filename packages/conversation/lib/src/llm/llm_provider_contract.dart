import 'package:equatable/equatable.dart';

enum ChatRole { system, user, assistant }

class ChatMessage extends Equatable {
  final ChatRole role;
  final String content;

  const ChatMessage({required this.role, required this.content});

  @override
  List<Object?> get props => [role, content];
}

abstract class LlmProviderContract {
  String get providerId;
  Future<String> generateCompletion({
    required String systemPrompt,
    required String userPrompt,
    List<ChatMessage> history = const [],
    double temperature = 0.7,
  });
}

class MockLlmProvider implements LlmProviderContract {
  @override
  String get providerId => 'mock_llm';

  @override
  Future<String> generateCompletion({
    required String systemPrompt,
    required String userPrompt,
    List<ChatMessage> history = const [],
    double temperature = 0.7,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (userPrompt.contains('Kaffee') || userPrompt.contains('heißen')) {
      return 'Sehr gerne! Ich bringe Ihnen sofort einen heißen Kaffee und ein frisches Croissant. Darf es noch etwas sein?';
    } else if (userPrompt.contains('Arzt') || userPrompt.contains('Kopfschmerzen')) {
      return 'Guten Tag! Setzen Sie sich bitte. Wie lange haben Sie diese Kopfschmerzen schon?';
    }

    return 'Guten Tag! Wie kann ich Ihnen heute in Wien behilflich sein?';
  }
}
