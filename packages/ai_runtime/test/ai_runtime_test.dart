import 'package:test/test.dart';
import 'package:dilang_ai_runtime/ai_runtime.dart';

class MockLlmProvider implements LlmProvider {
  @override
  Future<void> loadModel(String modelPath) async {}

  @override
  Future<StructuredOutput> generate({
    required PromptTemplate template,
    required String userInput,
  }) async {
    return const StructuredOutput(
      rawText: '{"response": "Das ist prima!", "events": []}',
      jsonPayload: {'response': 'Das ist prima!', 'events': <dynamic>[]},
      isValidJson: true,
    );
  }

  @override
  Stream<String> generateStream({
    required PromptTemplate template,
    required String userInput,
  }) async* {
    yield 'Das ist ';
    yield 'prima!';
  }

  @override
  Future<void> unloadModel() async {}
}

class MockSttProvider implements SttProvider {
  @override
  Future<void> loadModel(String modelPath) async {}

  @override
  Future<SttResult> transcribePcm16(List<int> pcmBytes, String languageCode) async {
    return const SttResult(transcription: 'Wie geht es dir?', confidence: 0.98);
  }

  @override
  Future<void> unloadModel() async {}
}

void main() {
  group('AI Runtime & Compute Platform Tests', () {
    test('1. ModelRegistry registers and queries model descriptors', () {
      final registry = ModelRegistry();

      const model = ModelDescriptor(
        modelId: 'qwen_0.5b',
        version: '1.0.0',
        name: 'Qwen 2.5 0.5B',
        backend: ModelBackend.llama_cpp,
        format: 'GGUF',
        quantization: 'Q4_K_M',
        sha256: 'abc123sha256',
        sizeBytes: 390000000,
        requiredRamBytes: 600000000,
        supportedCapabilities: ['chat', 'grammar'],
        targetLanguages: ['de-DE', 'es-ES'],
      );

      registry.registerModel(model);

      expect(registry.allModels.length, equals(1));
      expect(registry.getModel('qwen_0.5b'), equals(model));
      expect(registry.findByCapability('chat').length, equals(1));
    });

    test('2. ResourceScheduler calculates allocation plans based on hardware profile', () {
      final scheduler = ResourceScheduler();

      const lowRamHW = HardwareProfile(
        totalRamMb: 2000,
        availableRamMb: 300, // Insufficient for 600MB model
        cpuPhysicalCores: 4,
        hasGpuAcceleration: false,
        gpuBackendName: 'None',
      );

      final planLow = scheduler.scheduleAllocation(
        hardware: lowRamHW,
        requestedRamMb: 600,
        requestedContextTokens: 2048,
      );

      expect(planLow.allowExecution, isFalse);

      const highPowerHW = HardwareProfile(
        totalRamMb: 16000,
        availableRamMb: 8000,
        cpuPhysicalCores: 8,
        hasGpuAcceleration: true,
        gpuBackendName: 'Metal',
      );

      final planHigh = scheduler.scheduleAllocation(
        hardware: highPowerHW,
        requestedRamMb: 600,
        requestedContextTokens: 4096,
      );

      expect(planHigh.allowExecution, isTrue);
      expect(planHigh.gpuLayersToOffload, equals(32));
      expect(planHigh.threadsToUse, equals(7));
    });

    test('3. PromptBuilder constructs formatted section blocks', () {
      const template = PromptTemplate(
        systemRole: 'You are a language tutor.',
        sections: [
          PromptSection(title: 'CEFR', content: 'Target Level: A1'),
        ],
      );

      final prompt = template.buildPrompt('Hallo!');
      expect(prompt, contains('<SYSTEM>\nYou are a language tutor.'));
      expect(prompt, contains('<CEFR>\nTarget Level: A1'));
      expect(prompt, contains('<USER>\nHallo!'));
    });

    test('4. InferencePipeline executes STT -> LLM pipeline with telemetry diagnostics', () async {
      final pipeline = InferencePipeline(
        llmProvider: MockLlmProvider(),
        sttProvider: MockSttProvider(),
      );

      const template = PromptTemplate(systemRole: 'Tutor');

      final result = await pipeline.executeAudioPipeline(
        pcmAudioBytes: [0, 1, 2, 3],
        languageCode: 'de-DE',
        promptTemplate: template,
      );

      expect(result.sttResult?.transcription, equals('Wie geht es dir?'));
      expect(result.llmOutput.jsonPayload['response'], equals('Das ist prima!'));
      expect(result.diagnostics.latencyMs, greaterThanOrEqualTo(0));
    });
  });
}
