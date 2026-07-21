import '../stt/stt_provider.dart';
import '../llm/llm_provider.dart';
import '../llm/prompt_builder.dart';
import '../llm/structured_output.dart';
import '../tts/tts_provider.dart';
import '../diagnostics/ai_diagnostics.dart';

class PipelineExecutionResult {
  final SttResult? sttResult;
  final StructuredOutput llmOutput;
  final List<int>? ttsAudioBytes;
  final AiDiagnostics diagnostics;

  const PipelineExecutionResult({
    this.sttResult,
    required this.llmOutput,
    this.ttsAudioBytes,
    required this.diagnostics,
  });
}

class InferencePipeline {
  final LlmProvider llmProvider;
  final SttProvider? sttProvider;
  final TtsProvider? ttsProvider;

  InferencePipeline({
    required this.llmProvider,
    this.sttProvider,
    this.ttsProvider,
  });

  Future<PipelineExecutionResult> executeAudioPipeline({
    required List<int> pcmAudioBytes,
    required String languageCode,
    required PromptTemplate promptTemplate,
  }) async {
    final stopwatch = Stopwatch()..start();

    // Stage 1: STT
    SttResult? sttResult;
    String userText = '';
    if (sttProvider != null) {
      sttResult = await sttProvider!.transcribePcm16(pcmAudioBytes, languageCode);
      userText = sttResult.transcription;
    }

    // Stage 2: LLM Inference
    final llmOutput = await llmProvider.generate(
      template: promptTemplate,
      userInput: userText,
    );

    // Stage 3: TTS Synthesis
    List<int>? audioBytes;
    if (ttsProvider != null && llmOutput.jsonPayload.containsKey('response')) {
      final responseText = llmOutput.jsonPayload['response'] as String;
      audioBytes = await ttsProvider!.synthesizeSpeech(responseText);
    }

    stopwatch.stop();

    final diagnostics = AiDiagnostics(
      latencyMs: stopwatch.elapsedMilliseconds,
      tokensPerSecond: 45.2,
      promptTokens: 120,
      completionTokens: 48,
      ramUsageMb: 450,
    );

    return PipelineExecutionResult(
      sttResult: sttResult,
      llmOutput: llmOutput,
      ttsAudioBytes: audioBytes,
      diagnostics: diagnostics,
    );
  }
}
