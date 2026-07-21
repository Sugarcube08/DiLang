# 04. Implementation Phases & Roadmap — DiLang

**Document Version:** 1.0.0  
**Status:** Approved Roadmap

---

## Overview Strategy

DiLang development follows a strict 6-phase sequence. No phase may commence until all verification milestones of the preceding phase are validated against automated integration tests.

```
 +-------------------------------------------------------------------------+
 | PHASE 1: Contract Specification & Core Abstractions                      |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 | PHASE 2: Native C/FFI AI Infrastructure & Offline Engines                |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 | PHASE 3: Deterministic Learning Engine & Event Store                     |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 | PHASE 4: Core Bounded Contexts & Plugin Architecture                    |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 | PHASE 5: Cross-Platform UI & Interactive Design System                   |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 | PHASE 6: Local-First Sync Engine & Multi-Device Peer Protocol           |
 +-------------------------------------------------------------------------+
```

---

## Phase 1: Contract Specification & Core Abstractions
- [x] Define mandatory project documents (`01` through `10`).
- [ ] Implement Protobuf schemas for core entities and events (`.proto` files).
- [ ] Construct Dart abstract interfaces for Capability Providers (`LLMProvider`, `STTProvider`, `TTSProvider`, `EmbeddingProvider`).
- [ ] Build the core `EventBus` with priority queuing, retry policies, and logging handlers.
- [ ] Define Drift Database schemas for `EventStore` and projection tables.

## Phase 2: Native C/FFI AI Infrastructure
- [ ] Build CMake native C++ wrappers for `llama.cpp` (`libdilang_llama`).
- [ ] Build CMake native C++ wrappers for `whisper.cpp` (`libdilang_whisper`).
- [ ] Build C++ FFI wrappers for `Piper` TTS engine (`libdilang_piper`).
- [ ] Build dynamic library bindings for `BGE Small` vector embeddings.
- [ ] Validate cross-platform compilation on Linux, Windows, macOS, Android, and iOS.
- [ ] Construct model download/storage manager with sha256 checksum verification.

## Phase 3: Deterministic Learning Engine & Event Store
- [ ] Implement FSRS-4.5 (Free Spaced Repetition Scheduler) algorithm in pure Dart.
- [ ] Implement Learner Knowledge Graph structure and memory decay algorithms.
- [ ] Build Drift SQLite Event Store with WAL mode and transaction atomicity.
- [ ] Create projection rebuild utilities capable of re-hydrating state from event streams.

## Phase 4: Core Bounded Contexts & Plugin System
- [ ] **Vocabulary Context**: Flashcard queues, lexical relations, sentence extraction.
- [ ] **Grammar Context**: Structural rules, syntactic analyzer, error taxonomy.
- [ ] **Pronunciation Context**: Audio feature extraction, phonetic alignment against Whisper timestamps.
- [ ] **Conversation Context**: Dialogue state machine, turn manager, context RAG injector.
- [ ] **Plugin Host API**: `PluginHostContract`, dynamic asset loading, third-party language pack loader.

## Phase 5: Cross-Platform UI & Interactive Design System
- [ ] Implement DiLang Design Tokens (HSL palette, typography, glassmorphism, dynamic dark/light mode).
- [ ] Build reusable Flutter UI components (Interactive Voice Button, Phoneme Analyzer Chart, Graph Visualizer, Flashcard Deck).
- [ ] Assemble core app routes with `GoRouter` and state binding with `Riverpod`.
- [ ] Desktop responsiveness (Linux/macOS/Windows) and Mobile navigation polish (Android/iOS).

## Phase 6: Local-First Synchronization Engine
- [ ] Implement Protobuf delta packet serialization with LZ4 compression.
- [ ] Build gRPC sync client and server protocols for P2P network sync.
- [ ] Create conflict resolution algorithms (Vector Clocks + CRDTs for learner state).
