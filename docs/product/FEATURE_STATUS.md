# DiLang Feature Implementation Status

> **Single Source of Truth** for current development progress across all subsystem engines.

| Subsystem / Feature | Phase / Milestone | Status | Document Reference |
| :--- | :--- | :--- | :--- |
| Repository Governance & Constitution | Milestone 0 | **COMPLETED** | `README.md`, `AI_RULES.md` |
| Monorepo Structure & Toolchain Bootstrap | Milestone 0 | **VERIFIED & PASSED** | `crates/core`, `crates/ffi`, `apps/mobile` |
| Design System v1.0 & Token Architecture | Milestone 0.5 | **FROZEN & PASSED** | `docs/engineering/DESIGN_SYSTEM.md` |
| Rust Core Subsystem Module Skeleton | Milestone 1 | **COMPLETED** | `crates/core/src/` |
| Core Domain Models (User, Vocab, Review, Session) | Milestone 2 | **COMPLETED** | `crates/core/src/models/` |
| SQLite Schema (DDL v1, Indexes, Migrations) | Milestone 3 | **COMPLETED** | `crates/core/src/storage/schema.rs` |
| Public Engine API Facade & FFI Bridge | Milestone 4 | **VERIFIED & PASSED** | `crates/core/src/api.rs` |
| On-Device LLM (Gemma 3 1B llama.cpp) | Milestone 5 | Scheduled | `MODEL_PROVIDER_GUIDE.md` |
| Offline Speech STT Pipeline (Whisper.cpp) | Milestone 6 | Scheduled | `CONVERSATION_ENGINE.md` |
| Offline Voice TTS Pipeline (Piper ONNX) | Milestone 7 | Scheduled | `CONVERSATION_ENGINE.md` |
| Vector Knowledge Graph (sqlite-vec) | Milestone 8 | Scheduled | `MEMORY_SYSTEM.md` |
| E2EE CRDT Synchronization | Phase 4 | Scheduled | `SYNC_ARCHITECTURE.md` |
| WASM Plugin System | Phase 5 | Scheduled | `PLUGIN_SYSTEM.md` |
