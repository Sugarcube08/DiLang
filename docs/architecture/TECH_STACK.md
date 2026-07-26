# DiLang Technology Stack Specification 🛠️

> **Notice**: This root document is an alias to the primary tech stack specification located at [`docs/architecture/TECH_STACK.md`](docs/architecture/TECH_STACK.md).

For full details on the technology matrix, multimodal AI local engines (Gemma 3 1B, Whisper.cpp, Piper), SQLCipher + sqlite-vec integration, FSRS v5 scheduling math, and platform hardware acceleration matrices, please refer directly to:

👉 **[Primary Technology Stack Documentation (`docs/architecture/TECH_STACK.md`)](docs/architecture/TECH_STACK.md)**

---

## Tech Stack Summary

- **UI Framework**: Flutter 3.x (Dart 3.x), Riverpod 2.x, Impeller Engine.
- **Native Core**: Rust 2021/2024, Tokio 1.38+, `flutter_rust_bridge` v2.
- **Local AI Runtimes**: Gemma 3 1B GGUF (`llama.cpp`), `whisper.cpp` STT, `piper-rs` TTS.
- **Database & Storage**: SQLCipher (AES-256-GCM), `sqlite-vec` (384d/768d vector embeddings), FSRS v5 spaced repetition scheduler.
- **Sync & Security**: Yrs CRDTs, Noise Protocol E2EE, Wasmtime WASM sandbox.
