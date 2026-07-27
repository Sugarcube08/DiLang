# DiLang Local Model Provider & AI Runtime Guide 🤖📦

> **Notice**: This root document is an alias to the primary model provider specification located at [`docs/architecture/MODEL_PROVIDER_GUIDE.md`](docs/architecture/MODEL_PROVIDER_GUIDE.md).

For full details on the local LLM Rust trait abstractions (`LlamaModelProvider`, `WhisperModelProvider`, `PiperModelProvider`), GGUF Q4_K_M vs Q8_0 quantizations, RAM/VRAM resource allocation tiers, GPG/SHA-256 model verification pipelines, and token streaming callbacks, please refer directly to:

👉 **[Primary Model Provider Guide Documentation (`docs/architecture/MODEL_PROVIDER_GUIDE.md`)](docs/architecture/MODEL_PROVIDER_GUIDE.md)**

---

## Model Provider & Asset Manifest Architecture Summary

- **Engine Drivers**: `llama.cpp` for Qwen3-0.6B Instruct LLM, `whisper.cpp` for STT, `piper-rs` for ONNX TTS, FastEmbed for embeddings.
- **Dynamic Asset Manifest System**:
  - No hardcoded model URLs or SHA-256 constants in source code.
  - Manifest (`registry.json` / remote manifest server) supplies dynamic URLs, mirror arrays, versioning, size bytes, dynamic SHA-256, supported languages, and `minimumAppVersion`.
  - **Multi-Mirror Failover**: Automatic fallback across mirrors (HuggingFace, GitHub Releases, Cloudflare CDN) if primary download fails.
  - **Automatic Verification**: Downloads asset -> calculates SHA-256 dynamically -> validates against manifest hash or HTTP `etag` / `x-linked-etag` header.
- **Unified 24-Language Matrix (Day 1)**:
  - Supported: English, German, French, Spanish, Italian, Portuguese, Dutch, Polish, Russian, Chinese, Japanese, Korean, Hindi, Arabic (RTL), Turkish, Vietnamese, Thai, Indonesian, Swedish, Norwegian, Danish, Finnish, Greek, Czech.
  - Full $24 \times 24 = 576$ directional language pairing matrix. Zero privileged base language.
- **Application-Wide Localization Layer**:
  - Selected Source Language automatically becomes the entire application's interface language (Navigation, Buttons, Onboarding, Dialogs, Errors, Exercises, Review cards, AI system prompts, RTL support).
- **Unified Asset Manifest Scope**:
  - Covers Conversation Models, STT, TTS, Embeddings, Dictionaries, Phrase DBs, Morphology Packs, Grammar Packs, UI Localization Packs, Story Packs, Exercise Packs, Fonts.
- **AI Runtime Providers**:
  - **Conversation Provider**: `Qwen3-0.6B Instruct (GGUF)` (Conversation, Roleplay, Explanations, Hints, Stories, Adaptive dialogue)
  - **Translation Provider**: Deterministic pipeline (Dictionary Engine, Phrase KB, Morphological Analyzer, Translation Cache) + Optional Neural Translator (Bergamot/Marian/Argos plugin) + Qwen fallback
  - **Embedding Provider**: FastEmbed (BGE-small / e5-small)
  - **STT Provider**: Whisper.cpp
  - **TTS Provider**: Piper
- **Translation Retrieval Order**:
  `Tap` → `Phrase Cache` → `Phrase KB` → `Dictionary` → `Morphological Analyzer` → `Translation Memory` → `Optional Neural Translator` → `Qwen Fallback`
- **Translation Philosophy**: The Translation Provider resolves translations using deterministic linguistic resources. The conversation model is only used as a fallback for constructions that cannot be resolved through the local translation pipeline.
