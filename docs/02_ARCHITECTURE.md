# 02. System Architecture Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth  
**Architecture Patterns:** Clean Architecture, DDD, Event-Driven Architecture (EDA), Plugin-Oriented Architecture (POA)

---

## 1. System Overview & High-Level Architecture

DiLang is structured into four explicit, decoupled architectural layers. System dependencies flow strictly inwards: **Presentation $\rightarrow$ Infrastructure / Application $\rightarrow$ Domain**.

```
 +-----------------------------------------------------------------------+
 |                         PRESENTATION LAYER                            |
 |  Flutter Widgets | Riverpod Providers | GoRouter | UI Components      |
 +----------------------------------+------------------------------------+
                                    |
                                    v
 +-----------------------------------------------------------------------+
 |                         APPLICATION LAYER                             |
 |  Use Cases | Orchestrator Services | Event Handlers | Plugin Host     |
 +----------------------------------+------------------------------------+
                                    |
                                    v
 +-----------------------------------------------------------------------+
 |                           DOMAIN LAYER                                |
 |  Learner Graph | Domain Events | Invariants | Value Objects | Entities |
 +----------------------------------+------------------------------------+
                                    ^
                                    |
 +----------------------------------+------------------------------------+
 |                      INFRASTRUCTURE LAYER                             |
 |  Drift DB | Event Store | llama.cpp FFI | whisper FFI | Piper | gRPC  |
 +-----------------------------------------------------------------------+
```

---

## 2. Bounded Contexts (Domain-Driven Design)

DiLang is partitioned into seven primary Bounded Contexts. Each context maintains strict boundaries and interacts with other contexts *exclusively* via immutable Domain Events published to the central **Event Bus**.

```
 +-------------------+      Events      +-------------------+
 |  Conversation     |----------------->|  Vocabulary       |
 |  Context          |                  |  Context          |
 +-------------------+                  +-------------------+
           |                                      |
           | Events                               | Events
           v                                      v
 +-------------------+                  +-------------------+
 |  Grammar          |                  |  Learner Graph    |
 |  Context          |----------------->|  (Analytics Engine|
 +-------------------+                  +-------------------+
           |                                      ^
           | Events                               | Events
           v                                      |
 +-------------------+                  +-------------------+
 |  Pronunciation    |----------------->|  Sync & Storage   |
 |  Context          |                  |  Context          |
 +-------------------+                  +-------------------+
```

1. **Learner Graph Context**: Source of truth for mastery scores, retention curves (FSRS), item decay, and personalized learning trajectories.
2. **Vocabulary Context**: Lexical dictionary, word relationships, collocations, context sentences, and flashcard queues.
3. **Grammar Context**: Syntactic structures, morphological analyzer, rule definitions, and structural error classification.
4. **Pronunciation Context**: Acoustic evaluation, phoneme transcription analysis, pitch/stress tracking, and audio alignment.
5. **Conversation Context**: Turn-taking manager, dialogue scenario state, prompt templating, and discourse analysis.
6. **AI Infrastructure Context**: C/FFI wrappers around `llama.cpp`, `whisper.cpp`, `Piper`, and `BGE Small` embeddings engine.
7. **Storage & Sync Context**: SQLite/Drift ORM, Event Log append engine, LZ4 compression, and Protobuf/gRPC local-first sync manager.

---

## 3. Event-Driven Architecture & Event Bus Specification

### 3.1 Event Bus Design
The `EventBus` is an asynchronous, in-process event broker implemented in Dart with priority queues and backpressure controls.

- **Immutability**: Every event implements `DomainEvent` and contains a unique `eventId`, `timestamp`, `aggregateId`, and Protobuf payload.
- **Side-Effect Isolation**: Subscribing modules process events asynchronously. A crash in the Analytics Context subscriber cannot disrupt Conversation Context state execution.
- **Replayability**: State can be completely rebuilt by replaying the immutable event log from epoch $T_0$ to current time $T_{now}$.

---

## 4. Native AI Engine & C/FFI Integration

Local AI engines operate out-of-process or via direct C/FFI shared dynamic libraries (`.so`, `.dll`, `.dylib`) to ensure background UI performance remains at a solid 60/120 FPS.

```
 +-----------------------------------------------------------------------+
 |                             Dart VM                                   |
 |  llama_cpp_service.dart  |  whisper_service.dart  | piper_service.dart|
 +----------------------------------+------------------------------------+
                                    | C/FFI (dart:ffi)
                                    v
 +-----------------------------------------------------------------------+
 |                        Native Native Shared Libs                      |
 |  libdilang_llama.so   |   libdilang_whisper.so   |  libdilang_piper.so|
 +----------------------------------+------------------------------------+
                                    | Native Hardware Acceleration
                                    v
 +-----------------------------------------------------------------------+
 |                 Hardware Acceleration Drivers / APIs                  |
 |  Vulkan / Metal / CoreML / CUDA / OpenCL / Android NNAPI / CPU AVX2  |
 +-----------------------------------------------------------------------+
```

---

## 5. Plugin-Oriented Architecture (POA)

DiLang features a host API enabling 3rd-party language modules, custom exercise engines, and external dictionary providers.

- **Isolation**: Plugins interact via `PluginHostContract`. They do not possess direct raw access to SQLite connection instances or internal LLM C-pointers.
- **Registration**: Plugins declare capabilities via `PluginManifest` (Protobuf) defining target languages, custom exercise widgets, and event hooks.
- **Extensibility**: Addition of a new language (e.g., Japanese, Spanish, Arabic) requires only registering a new Language Pack plugin containing dictionary databases, FSRS parameters, and whisper/piper voice models.
