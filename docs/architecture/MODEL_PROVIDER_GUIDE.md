# DiLang Local Model Provider & AI Runtime Guide 🤖📦

> **Notice**: This root document is an alias to the primary model provider specification located at [`docs/architecture/MODEL_PROVIDER_GUIDE.md`](docs/architecture/MODEL_PROVIDER_GUIDE.md).

For full details on the local LLM Rust trait abstractions (`LlamaModelProvider`, `WhisperModelProvider`, `PiperModelProvider`), GGUF Q4_K_M vs Q8_0 quantizations, RAM/VRAM resource allocation tiers, GPG/SHA-256 model verification pipelines, and token streaming callbacks, please refer directly to:

👉 **[Primary Model Provider Guide Documentation (`docs/architecture/MODEL_PROVIDER_GUIDE.md`)](docs/architecture/MODEL_PROVIDER_GUIDE.md)**

---

## Model Provider Summary

- **Engine Drivers**: `llama.cpp` for Gemma 3 1B LLM, `whisper.cpp` for STT, `piper-rs` for ONNX TTS.
- **Quantization Standard**: Gemma 3 1B GGUF Q4_K_M (~800MB RAM) for mobile, Q8_0 (~1.4GB RAM) for desktop.
- **Resource Governor**: Dynamic RAM/VRAM profiling with memory eviction and context window sliding (2k–8k tokens).
- **Integrity**: HTTPS chunked resume downloader, SHA-256 checksum verification, GPG signature check.
