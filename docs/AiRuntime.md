# DiLang — AI Infrastructure Specification

**Version**: 2.1-FROZEN  
**Status**: Frozen & Authoritative  

---

## 1. AI Infrastructure Subsystem

AI compute is categorized entirely under `lib/infrastructure/ai/`:

```text
infrastructure/ai/
├── providers/          # Pluggable LLM provider implementations (Local, Gemini, OpenAI, Claude, Ollama)
├── model_registry/     # Model descriptors, RAM allocation & quantization checks
├── prompting/          # Adaptive prompt assembly templates & structured output parsers
└── embeddings/         # Vector embedding calculation drivers
```

---

## 2. Pluggable `LlmProvider` Abstraction

```dart
abstract class LlmProvider {
  Future<void> initialize();
  Future<LlmResponse> generateResponse({
    required String systemPrompt,
    required String userInput,
    required Map<String, dynamic> context,
  });
  Stream<String> streamResponse({
    required String systemPrompt,
    required String userInput,
  });
  Future<void> dispose();
}
```

---

## 3. Strict Layering Rules

- AI is infrastructure. Feature modules (`conversation`, `learning`) consume AI infrastructure interfaces.
- The UI and controllers interact exclusively through module services and `DiLangRuntime`.
- Production code MUST NOT contain mock AI providers.
