# DiLang System Design Specification ⚙️

> **Notice**: This root document is an alias to the primary system design specification located at [`docs/architecture/SYSTEM_DESIGN.md`](docs/architecture/SYSTEM_DESIGN.md).

For full details on subsystem topology, event loops, crate dependency graphs, end-to-end speech-LLM-TTS message flows, and FFI CQRS patterns, please refer directly to:

👉 **[Primary System Design Documentation (`docs/architecture/SYSTEM_DESIGN.md`)](docs/architecture/SYSTEM_DESIGN.md)**

---

## System Topology Summary

- **Subsystems**: Decoupled Flutter UI, Rust Core Orchestrator, Multimodal Local AI Runtimes (Llama.cpp, Whisper.cpp, Piper), Storage Subsystem (SQLCipher + sqlite-vec + FSRS), Sync Subsystem (Yrs CRDTs), and WASM Sandbox.
- **Event Loops**: Dart Event Loop (UI), Tokio Multi-Threaded Event Loop (Async Rust Engine), and Native OS Real-time Audio Loop.
- **Crate Architecture**: Unidirectional dependency graph (`dilang_core` -> `dilang_models`, `dilang_sqlite`, `dilang_sync`, `dilang_plugin` -> `dilang_fsrs`).
- **Communication Protocol**: CQRS (Commands, Queries, Event Streams) via `flutter_rust_bridge` v2 FFI.
