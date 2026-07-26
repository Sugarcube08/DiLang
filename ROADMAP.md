# DiLang Strategic Product Roadmap 🗺️

This document outlines the multi-year vision and release phases for **DiLang**. As an open-source, local-first platform, our goal is to deliver an uncompromised, privacy-focused AI language learning experience across all major operating systems.

---

## 🎯 Strategic Roadmap Overview

```
┌─────────────────────────────────────────────────────────────┐
│ Phase 1: Governance & Core Architecture Foundation          │ (Q3 2026)
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│ Phase 2: Rust Engine Core & Flutter FFI Bridge               │ (Q4 2026)
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│ Phase 3: On-Device AI Inference (Gemma 3, Whisper, Piper)   │ (Q1 2027)
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│ Phase 4: Knowledge Graph, Spaced Repetition & Local Sync    │ (Q2-Q3 2027)
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│ Phase 5: Multiplatform Release & Ecosystem Marketplace     │ (Q4 2027+)
└─────────────────────────────────────────────────────────────┘
```

---

## 🚩 Phase 1: Governance & Core Architecture Foundation (Q3 2026)

**Focus**: Repository initialization, open-source governance, CI/CD infrastructure, and architectural design records.

- [x] AGPLv3 + Commercial dual-licensing legal structure.
- [x] Engineering contribution guidelines, DCO sign-off, Code of Conduct, and Security threat model.
- [x] Semantic versioning specification for Rust crates, Flutter app, and Language Packs schema.
- [x] GitHub Actions automated CI pipeline (`.github/workflows/ci.yml`).
- [ ] Define cross-language FFI boundary patterns using `flutter_rust_bridge` v2.
- [ ] Establish initial architectural decision records (ADR 001–ADR 005).

---

## ⚙️ Phase 2: Rust Engine Core & Flutter Shell Bridge (Q4 2026)

**Focus**: Establishing high-performance native core modules in Rust and connecting them smoothly to Flutter UI.

- [ ] **`dilang_core`**: Common data structures, configuration parsing, error handling.
- [ ] **`dilang_storage`**:
  - Encrypted SQLite schema initialization with SQLCipher.
  - FSRS-4.5 (Free Spaced Repetition Scheduler) algorithm engine implementation.
  - Efficient batch query performance for vocabulary cards and lesson state.
- [ ] **`dilang_bridge`**: `flutter_rust_bridge` async bindings generation for zero-copy state synchronization between Rust and Dart.
- [ ] **Flutter UI Shell**: Design system initialization with Material 3, customizable dark mode, dynamic typography, and responsive navigation layouts.

---

## 🤖 Phase 3: On-Device AI Inference Engines (Q1 2027)

**Focus**: Integrating quantized LLM, STT, and TTS engines into Rust (`dilang_inference`) for 100% offline execution.

- [ ] **Large Language Model (LLM)**:
  - Integrate **Gemma 3 1B** (GGUF 4-bit / 8-bit quantized) using `llama.cpp` Rust bindings.
  - System prompts and grammar correction engine for real-time conversation feedback.
- [ ] **Speech-to-Text (STT)**:
  - Integrate **Whisper.cpp** for low-latency streaming audio transcription.
  - VAD (Voice Activity Detection) integration to trim silences locally.
- [ ] **Text-to-Speech (TTS)**:
  - Integrate **Piper TTS** for neural speech synthesis.
  - Audio streaming pipeline directly into Flutter audio output handlers.
- [ ] Memory & thermal budget manager to maintain < 2.5 GB peak RAM consumption on mobile hardware.

---

## 🧠 Phase 4: Knowledge Graph, Spaced Repetition & Local Sync (Q2-Q3 2027)

**Focus**: Intelligent memory models, vector similarity search, and peer-to-peer device sync.

- [ ] **Local Knowledge Graph**:
  - SQLite-based vector index for word embeddings, contextual semantic relationships, and grammar pattern links.
  - Automatic sentence breakdown and vocabulary extraction from dialogue sessions.
- [ ] **Local-First P2P Sync Engine (`dilang_sync`)**:
  - Conflict-free Replicated Data Types (CRDTs) for multi-device sync over local Wi-Fi / Bluetooth.
  - End-to-end encrypted backup import/export format.
- [ ] Interactive learning modes: Roleplay scenarios, contextual flashcards, listening comprehension exercises.

---

## 🌐 Phase 5: Multiplatform Release & Community Ecosystem (Q4 2027+)

**Focus**: Store distribution across Android, iOS, macOS, Linux, and Windows, alongside community Language Packs.

- [ ] **Cross-Platform Release**:
  - Android (Google Play Store & F-Droid) APK / AAB builds.
  - iOS App Store IPA builds.
  - Desktop installers (macOS `.dmg`/macOS App Store, Linux `.AppImage`/`Flathub`, Windows `.msi`).
- [ ] **Language Pack Packaging Standard**:
  - Standardized JSON/SQLite bundle format for community language packs (grammar rules, dictionaries, pre-tuned voice assets).
  - Web-based language pack validator tool.
- [ ] Enterprise & Commercial licensing portal.

---

*Roadmap milestones are subject to community RFC feedback and ADR approvals.*
