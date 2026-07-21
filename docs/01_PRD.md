# 01. Product Requirements Document (PRD) — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth  
**Target Platform:** Linux, Windows, macOS, Android, iOS (Single Flutter Codebase)

---

## 1. Executive Summary & Mission Statement

**DiLang** is not a conventional language-learning app. It is a production-grade, offline-first, AI-native **Language Acquisition Platform** engineered as a modular learning operating system.

Unlike consumer applications that rely on static linear paths or cloud-bound LLM prompts for business logic, DiLang treats Artificial Intelligence as raw infrastructure. Learner progress, spaced-repetition schedules, vocabulary mastery, and skill graphs are owned entirely by a **deterministic Learning Engine**. 

DiLang models, measures, and elevates a learner's language proficiency across seven primary skill modalities:
1. **Vocabulary** (lexical breadth, depth, passive vs. active recall)
2. **Grammar** (structural syntax, inflection, error taxonomy)
3. **Pronunciation** (phonetic accuracy, pitch contour, rhythm)
4. **Listening** (auditory comprehension, speed adaptability, phoneme discrimination)
5. **Writing** (composition, orthography, semantic clarity)
6. **Reading** (comprehension speed, morphological parsing)
7. **Conversation** (real-time pragmatics, fluidity, discourse management)

---

## 2. Core Architectural & Product Philosophy

1. **Deterministic Learning Engine**: Algorithms (e.g., FSRS-4.5 / modified SuperMemo, Knowledge Tracing Graphs) govern memory retention, interval calculations, and skill mastery. LLMs do *not* decide when a word is learned.
2. **AI as Infrastructure**: LLMs, STT, TTS, and Vector Embeddings are swappable capability providers behind strict C/FFI and IPC interfaces.
3. **Offline-First & Local-First Data Ownership**: 100% of core learning features, local database storage, and AI inference execute completely without an active internet connection.
4. **Event-Driven Decoupling**: Modules emit immutable domain events. Cross-module communication is entirely asynchronous via a central event bus.
5. **Contract-First Specification**: All domain models, event payloads, capability APIs, storage interfaces, and AI boundaries are declared prior to implementation.
6. **Multi-Platform Consistency**: Unified UI/UX delivered across mobile and desktop environments via Flutter, Riverpod, and Drift SQLite.

---

## 3. Key Functional Requirements

### 3.1 Core Learning Operating System
- **Learner Graph Engine**: Maintains a real-time directed acyclic graph (DAG) of the learner's knowledge state across lexical items, grammatical rules, and phonetic markers.
- **Multimodal Exercise Framework**: Supports interactive flashcards, dictation, cloze tests, dialogue simulations, freeform composition, and listening drills.
- **Spaced Repetition System (SRS)**: Local deterministic scheduling using FSRS (Free Spaced Repetition Scheduler) principles operating on SQLite/Drift.

### 3.2 Offline AI Infrastructure
- **LLM Engine (`llama.cpp`)**: On-device conversation generation, grammar explanations, semantic translations, and context extraction using Qwen 2.5 0.5B (mobile-optimized) and Gemma 3 1B (universal/desktop).
- **Speech-to-Text (`whisper.cpp`)**: Offline real-time and batch audio transcription with timestamped phoneme alignment.
- **Text-to-Speech (`Piper`)**: High-speed, local neural speech synthesis supporting multi-speaker language packs.
- **Vector Embeddings (`BGE Small`)**: Local semantic search, similarity scoring, and dynamic retrieval-augmented generation (RAG) for contextual exercises.

### 3.3 Event-Sourced Storage & Sync
- **Event Journal**: All user actions and system state transitions are appended to an immutable SQLite event log.
- **Local State Projection**: Relational tables (Drift) represent current read states derived deterministically from the event log.
- **Local-First Synchronization**: Peer-to-peer or server-assisted delta synchronization using Protocol Buffers over gRPC with LZ4 compression when online.

---

## 4. Non-Functional Requirements & Performance Targets

| Metric | Target | Verification Standard |
| :--- | :--- | :--- |
| **App Cold Boot Time** | `< 1.2s` on desktop, `< 1.8s` on mobile | Benchmark execution script |
| **Local LLM TTFT (Time To First Token)** | `< 350ms` (Qwen 2.5 0.5B quantized Q4_K_M) | C++ FFI timing telemetry |
| **STT Latency** | `< 500ms` for 3-second audio snippet | `whisper.cpp` benchmark harness |
| **TTS Latency** | `< 200ms` audio chunk generation | `Piper` native stream benchmark |
| **DB Event Read / Write** | `< 5ms` per event transaction | SQLite / Drift WAL mode benchmark |
| **Offline Feature Coverage** | `100%` core learning functionality | Network-disabled integration tests |
| **Memory Footprint** | `< 800MB` RAM during active LLM inference | OS Process Monitor / Profiler |

---

## 5. Technology Stack & Hard Constraints

- **Client UI Framework**: Flutter (3.x stable)
- **State Management**: Riverpod (2.x code-gen)
- **Navigation & Routing**: GoRouter
- **Database Engine**: SQLite with `Drift` ORM & SQLCipher support
- **Serialization & Wire Protocol**: Protocol Buffers (`proto3`)
- **Transport / IPC**: gRPC & C/C++ Direct FFI bindings
- **Compression Protocol**: LZ4
- **Disallowed Technologies**: Firebase, Supabase, MongoDB, Realm, Electron, React Native, REST-first APIs, Cloud-only authentication.
