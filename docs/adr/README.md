# DiLang Architectural Decision Records (ADRs)

## 1. Overview & Process

This repository uses Architectural Decision Records (ADRs) to document significant architectural, design, framework, and technology stack choices made during the evolution of DiLang v2.

---

## 2. ADR Status Legend

- 🟢 **ACCEPTED**: Proposal approved and currently implemented in the codebase.
- 🟡 **PROPOSED**: Under active review by core architectural maintainers.
- 🔴 **REJECTED**: Evaluated and explicitly rejected.
- 🟣 **SUPERSEDED**: Replaced by a newer ADR.

---

## 3. ADR Index

| ADR ID | Title | Status | Primary Domain |
| :--- | :--- | :---: | :--- |
| [0001](0001-flutter-frontend.md) | Adopt Flutter for Multi-Platform Native Frontend | 🟢 ACCEPTED | Frontend / UI Layer |
| [0002](0002-rust-core-and-frb.md) | Implement Core Engines in Rust with `flutter_rust_bridge` | 🟢 ACCEPTED | Core Architecture |
| [0003](0003-sqlite-local-storage.md) | Standardize Local Storage on SQLite & `sqlx` | 🟢 ACCEPTED | Persistence Layer |
| [0004](0004-local-llm-qwen3-llamacpp.md) | Local LLM Execution with Qwen3-0.6B Instruct & `llama.cpp` | 🟢 ACCEPTED | AI / LLM Engine |
| [0005](0005-whisper-stt.md) | Local Speech-to-Text via Whisper C++ Bindings | 🟢 ACCEPTED | AI / Speech Ingestion |
| [0006](0006-piper-tts.md) | Local Speech Synthesis via Piper Neural Voice | 🟢 ACCEPTED | AI / Audio Synthesis |
| [0007](0007-provider-architecture.md) | Riverpod State Provider Architecture in Flutter | 🟢 ACCEPTED | Frontend State |
| [0008](0008-plugin-architecture.md) | Language Pack & Scenario Plugin Architecture | 🟢 ACCEPTED | Extensibility |
| [0009](0009-offline-first-sync.md) | Offline-First Data Model & P2P Sync | 🟢 ACCEPTED | Data Sovereignty |
| [0010](0010-local-knowledge-graph.md) | Epistemic Local Knowledge Graph & Vector Store | 🟢 ACCEPTED | Epistemic Memory |
| [0011](0011-fsrs-spaced-repetition.md) | Adopt Free Spaced Repetition Scheduler v4 (FSRS-v4) | 🟢 ACCEPTED | Memory Scheduling |
