# 09. Capability Interfaces & API Contracts — DiLang

**Document Version:** 1.0.0  
**Status:** Source of Truth — Interface Contracts

---

## 1. Capability Interfaces (AI Infrastructure Contracts)

These abstract interfaces isolate all application modules from specific local AI implementation details (`llama.cpp`, `whisper.cpp`, `Piper`, `BGE Small`).

```dart
/// Abstract contract for offline Large Language Model inference
abstract class LLMCapabilityInterface {
  Future<void> initialize({
    required String modelPath,
    required int contextSize,
    required int threads,
    bool useGpu = true,
  });

  Stream<String> generateStream({
    required String prompt,
    required double temperature,
    required double topP,
    required int maxTokens,
    List<String>? stopTokens,
  });

  Future<String> generateCompletion({
    required String prompt,
    required double temperature,
    required double topP,
    required int maxTokens,
  });

  Future<void> dispose();
}

/// Abstract contract for Speech-to-Text inference
abstract class STTCapabilityInterface {
  Future<void> initialize({required String modelPath});

  Future<STTResult> transcribeAudio({
    required String pcmAudioFilePath,
    required String language,
  });

  Future<void> dispose();
}

class STTResult {
  final String transcription;
  final List<PhonemeTiming> phonemes;
  final double confidence;

  const STTResult({
    required this.transcription,
    required this.phonemes,
    required this.confidence,
  });
}

class PhonemeTiming {
  final String symbol;
  final int startMs;
  final int endMs;
  final double score;

  const PhonemeTiming({
    required this.symbol,
    required this.startMs,
    required this.endMs,
    required this.score,
  });
}

/// Abstract contract for Text-to-Speech inference
abstract class TTSCapabilityInterface {
  Future<void> initialize({required String modelPath, required String voiceConfigPath});

  Future<String> synthesizeToFile({
    required String text,
    required String outputPath,
    double speechRate = 1.0,
  });

  Future<void> dispose();
}

/// Abstract contract for Vector Embeddings
abstract class EmbeddingCapabilityInterface {
  Future<void> initialize({required String modelPath});

  Future<List<double>> generateEmbedding(String text);

  Future<List<List<double>>> generateBatchEmbeddings(List<String> texts);
}
```

---

## 2. Storage & Repository Contracts

```dart
/// Abstract contract for append-only Domain Event Storage
abstract class EventStoreContract {
  Future<void> appendEvent({
    required String aggregateId,
    required String eventType,
    required List<int> protobufPayload,
    required String producerModule,
  });

  Stream<DomainEventEnvelope> readEventStream({
    int startSequence = 0,
    String? aggregateIdFilter,
  });

  Future<int> getLatestSequenceNumber();
}

/// Abstract contract for Learner Graph Queries & State Operations
abstract class LearnerGraphRepositoryContract {
  Future<FsrsMemoryState?> getMemoryState(String itemKey);

  Future<void> updateMemoryState({
    required String itemKey,
    required FsrsMemoryState newState,
  });

  Future<List<LexicalUnit>> getDueReviews({
    required DateTime currentTimestamp,
    required int limit,
  });
}
```

---

## 3. Plugin Host Contract

```dart
abstract class PluginHostContract {
  void registerPlugin(DiLangPlugin plugin);
  void notifyEventEmitted(DomainEventEnvelope event);
  List<DiLangPlugin> getActivePlugins();
}

abstract class DiLangPlugin {
  String get pluginId;
  String get name;
  String get version;
  
  Future<void> onInitialize(PluginHostContract host);
  void onEvent(DomainEventEnvelope event);
  Future<void> onDispose();
}
```
