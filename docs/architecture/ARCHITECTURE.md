# DiLang System Architecture 🏗️

> **Notice**: This root document is an alias to the primary architectural specification located at [`docs/architecture/ARCHITECTURE.md`](docs/architecture/ARCHITECTURE.md).

For the full, detailed technical specification including structural blueprints, high-level diagrams, Flutter UI specifications, `flutter_rust_bridge` v2 bindings, threading models, and memory allocation budgets, please refer directly to:

👉 **[Primary Architecture Documentation (`docs/architecture/ARCHITECTURE.md`)](docs/architecture/ARCHITECTURE.md)**

---

## Architecture Summary Overview

- **UI & Presentation**: Flutter 3.x (Dart 3.x), Riverpod state management, Material 3, Impeller rendering backend.
- **Native Engine Core**: Rust 2021/2024 workspace (`dilang_core`, `dilang_models`, `dilang_sqlite`, `dilang_fsrs`, `dilang_sync`, `dilang_plugin`).
- **Cross-Language FFI Boundary**: `flutter_rust_bridge` v2 zero-copy streams and type-safe FFI mappings.
- **Local Multimodal AI**: On-device quantized Gemma 3 1B LLM (`llama.cpp`), Speech-to-Text (`whisper.cpp`), Text-to-Speech (`piper-rs`).
- **Data & Storage**: Local-first SQLCipher encrypted SQLite with `sqlite-vec` vector similarity search and FSRS v5 spaced repetition.
- **Offline Sovereignty**: Zero telemetry, 100% offline-first execution, optional E2EE local P2P sync.
