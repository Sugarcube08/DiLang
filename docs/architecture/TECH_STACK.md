# DiLang Technology Stack Specification 🛠️

> **Notice**: This root document is an alias to the primary tech stack specification located at [`docs/architecture/TECH_STACK.md`](docs/architecture/TECH_STACK.md).

For full details on the technology matrix, multimodal AI local engines (Qwen3-0.6B Instruct GGUF, Whisper.cpp, Piper), SQLCipher + sqlite-vec integration, FSRS v5 scheduling math, and platform hardware acceleration matrices, please refer directly to:

👉 **[Primary Technology Stack Documentation (`docs/architecture/TECH_STACK.md`)](docs/architecture/TECH_STACK.md)**

---

## Tech Stack Summary

- **UI Framework**: Flutter 3.x (Dart 3.x), Riverpod 2.x, Impeller Engine.
- **Native Core**: Rust 2021/2024, Tokio 1.38+, `flutter_rust_bridge` v2.
- **Local AI Runtimes**: Qwen3-0.6B Instruct GGUF (`llama.cpp`), `whisper.cpp` STT, `piper-rs` TTS, FastEmbed (BGE-small/e5-small).
- **Translation Provider**: SQLite Dictionary -> Phrase KB -> Morphology -> Translation Cache -> Optional Neural Translator -> Qwen Fallback.
- **Database & Storage**: SQLCipher (AES-256-GCM), `sqlite-vec` (384d/768d vector embeddings), FSRS v5 spaced repetition scheduler.
- **Sync & Security**: Yrs CRDTs, Noise Protocol E2EE, Wasmtime WASM sandbox.
