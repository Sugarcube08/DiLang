import 'package:flutter_test/flutter_test.dart';
import 'package:dilang/infrastructure/ai/ai_runtime.dart';
import 'package:dilang/infrastructure/ai/model_registry/model_registry.dart';
import 'package:dilang/infrastructure/ai/prompting/prompt_pipeline.dart';
import 'package:dilang/infrastructure/ai/providers/ai_provider.dart';

void main() {
  group('Step 5 AI Infrastructure & AI Runtime Tests', () {
    test('1. ModelRegistry exposes model descriptors and capabilities', () {
      final models = ModelRegistry.availableModels;
      expect(models.length, greaterThanOrEqualTo(6));

      final gemini = ModelRegistry.findById('gemini-2.5-flash');
      expect(gemini.displayName, equals('Gemini 2.5 Flash'));
      expect(gemini.capabilities.supportsStreaming, isTrue);
      expect(gemini.capabilities.supportsJsonOutput, isTrue);
    });

    test('2. PromptPipeline assembles structured prompt context', () async {
      final pipeline = PromptPipeline();
      final ctx = await pipeline.assemble(
        systemPrompt: 'You are an AI language coach.',
        identityContext: 'Learner: Alice (German A1)',
        userInput: 'Wie geht es dir?',
      );

      final fullPrompt = ctx.assembleFullPrompt();
      expect(fullPrompt, contains('=== SYSTEM INSTRUCTIONS ==='));
      expect(fullPrompt, contains('Learner: Alice (German A1)'));
      expect(fullPrompt, contains('Wie geht es dir?'));
    });

    test('3. AiRuntime executes inference and measures response latency', () async {
      final aiRuntime = AiRuntime(activeProvider: GeminiAiProvider());
      await aiRuntime.initialize();

      aiRuntime.setModel('gemini-2.5-flash');
      expect(aiRuntime.activeModel.id, equals('gemini-2.5-flash'));

      final response = await aiRuntime.executeInference(
        systemPrompt: 'Respond politely.',
        userInput: 'Hallo!',
      );

      expect(response, contains('Gemini Inference Response'));
      expect(aiRuntime.lastResponseLatencyMs, greaterThanOrEqualTo(0));
    });

    test('4. AiRuntime streams tokens dynamically', () async {
      final aiRuntime = AiRuntime(activeProvider: LocalLlamaAiProvider());
      final stream = aiRuntime.streamInference(
        systemPrompt: 'Translate to German',
        userInput: 'Good morning',
      );

      final tokens = await stream.toList();
      expect(tokens, contains('Local '));
      expect(tokens, contains('llama.cpp '));
    });
  });
}
