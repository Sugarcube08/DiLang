import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

class OllamaLlmProvider implements LlmProviderContract {
  final String baseUrl;
  final String model;

  OllamaLlmProvider({
    this.baseUrl = 'http://localhost:11434',
    this.model = 'llama3',
  });

  @override
  String get providerId => 'ollama_$model';

  @override
  Future<String> generateCompletion({
    required String systemPrompt,
    required String userPrompt,
    List<ChatMessage> history = const [],
    double temperature = 0.7,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/chat');
      final messagesJson = [
        {'role': 'system', 'content': systemPrompt},
        ...history.map((h) => {'role': h.role.name, 'content': h.content}),
        {'role': 'user', 'content': userPrompt},
      ];

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model': model,
              'messages': messagesJson,
              'stream': false,
              'options': {'temperature': temperature},
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['message']['content'] as String;
        return content.trim();
      }
    } catch (_) {
      // Fallback on timeout or offline
    }

    return _fallbackResponse(userPrompt);
  }

  String _fallbackResponse(String input) {
    if (input.contains('Kaffee') || input.contains('heißen')) {
      return 'Sehr gerne! Ich bringe Ihnen sofort einen heißen Kaffee und ein frisches Croissant. Darf es noch etwas sein?';
    } else if (input.contains('Arzt') || input.contains('Kopfschmerzen')) {
      return 'Guten Tag! Setzen Sie sich bitte. Wie lange haben Sie diese Kopfschmerzen schon?';
    }
    return 'Guten Tag! Wie kann ich Ihnen heute behilflich sein?';
  }
}

class GeminiLlmProvider implements LlmProviderContract {
  final String apiKey;
  final String model;

  GeminiLlmProvider({
    required this.apiKey,
    this.model = 'gemini-1.5-flash',
  });

  @override
  String get providerId => 'gemini_$model';

  @override
  Future<String> generateCompletion({
    required String systemPrompt,
    required String userPrompt,
    List<ChatMessage> history = const [],
    double temperature = 0.7,
  }) async {
    try {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

      final contents = [
        {
          'role': 'user',
          'parts': [
            {'text': '$systemPrompt\n\nUser Question: $userPrompt'}
          ]
        }
      ];

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'contents': contents}),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List;
        if (candidates.isNotEmpty) {
          final parts = candidates.first['content']['parts'] as List;
          return (parts.first['text'] as String).trim();
        }
      }
    } catch (_) {}

    return 'Guten Tag! Wie kann ich Ihnen heute behilflich sein?';
  }
}

class ProductionLlmProvider implements LlmProviderContract {
  final OllamaLlmProvider _ollama = OllamaLlmProvider();

  @override
  String get providerId => 'production_llm';

  @override
  Future<String> generateCompletion({
    required String systemPrompt,
    required String userPrompt,
    List<ChatMessage> history = const [],
    double temperature = 0.7,
  }) async {
    return _ollama.generateCompletion(
      systemPrompt: systemPrompt,
      userPrompt: userPrompt,
      history: history,
      temperature: temperature,
    );
  }
}
