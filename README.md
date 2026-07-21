# DiLang — Modular AI-Native Language Acquisition Operating System

[![Build Status](https://img.shields.io/badge/CI-passing-brightgreen)](https://github.com/dilang/dilang)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue)](LICENSE)
[![Dart Version](https://img.shields.io/badge/Dart-3.0%2B-0175C2)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%7C%20DDD%20%7C%20Event--Driven-purple)](docs/02_ARCHITECTURE.md)

---

## Executive Summary & Vision

**DiLang** is an offline-first, AI-native **Language Acquisition Platform** designed as a modular learning operating system rather than a traditional language application.

The objective is not merely to teach vocabulary or grammar but to continuously model, measure, and elevate a learner's language ability through conversation, pronunciation, writing, reading, listening, and adaptive exercises.

---

## Core Philosophy

- **Deterministic Learning Engine**: Memory algorithms (FSRS-4.5) and learner graphs govern mastery. LLMs do *not* own user progress.
- **AI as Infrastructure**: Local LLMs (`llama.cpp`), Speech-to-Text (`whisper.cpp`), and Text-to-Speech (`Piper`) operate behind C/FFI contracts as pure infrastructure.
- **Offline-First & Local Data Ownership**: 100% of learning functionality, storage, and inference execute without internet.
- **Event-Driven Architecture**: Decoupled domain contexts publish immutable domain events to an in-process Event Bus.

---

## Technology Stack

| Component | Choice |
| :--- | :--- |
| **Client UI** | Flutter (Multi-platform desktop/mobile) |
| **State Management** | Riverpod 2.x |
| **Database** | SQLite + Drift ORM |
| **LLM Runtime** | `llama.cpp` (Qwen 2.5 0.5B / Gemma 3 1B) |
| **Speech-to-Text** | `whisper.cpp` |
| **Text-to-Speech** | `Piper` |
| **Embeddings** | `BGE Small` |
| **Serialization** | Protocol Buffers (`proto3`) |
| **Compression** | LZ4 |

---

## Package Overview

```text
packages/
├── core/         # Pure Dart Core Kernel (Kernel, EventBus, CapabilityRegistry, Plugins)
├── language/     # Language Intelligence Domain (Phonetics, Vocabulary, Grammar, Phrases)
├── learner/      # Learner State & Knowledge Graph
└── memory/       # Human Memory Engine (FSRS-4.5 Spaced Repetition Math)
```

---

## Documentation Index

Detailed architectural specifications and contracts are maintained in [/docs](docs/):

1. [01_PRD.md](docs/01_PRD.md) — Product Requirements Document
2. [02_ARCHITECTURE.md](docs/02_ARCHITECTURE.md) — System Architecture Blueprint
3. [03_RULES.md](docs/03_RULES.md) — Development & Architectural Rules
4. [04_PHASES.md](docs/04_PHASES.md) — Roadmap & Implementation Phases
5. [05_DESIGN.md](docs/05_DESIGN.md) — UI/UX & Design System Tokens
6. [06_MEMORY.md](docs/06_MEMORY.md) — Architectural Decision Records (ADRs)
7. [07_DOMAIN_MODEL.md](docs/07_DOMAIN_MODEL.md) — Domain Models & Learner Graph
8. [08_EVENT_CATALOG.md](docs/08_EVENT_CATALOG.md) — Domain Event Schemas & Protobuf
9. [09_API_CONTRACTS.md](docs/09_API_CONTRACTS.md) — Capability & Storage Interfaces
10. [10_AI_RUNTIME.md](docs/10_AI_RUNTIME.md) — Offline AI & C/FFI Infrastructure
11. [11_PLATFORM_FOUNDATION.md](docs/11_PLATFORM_FOUNDATION.md) — Core Platform Spec & Phase 0
12. [12_LANGUAGE_SPECIFICATION.md](docs/12_LANGUAGE_SPECIFICATION.md) — Language Domain Data Spec
13. [13_ENGINEERING_GUIDELINES.md](docs/13_ENGINEERING_GUIDELINES.md) — Human Engineering Practices

---

## Quickstart & Development

### Prerequisites
- Dart SDK 3.0+
- Melos (`dart pub global activate melos`)

### Run Tests Across Monorepo
```bash
# Bootstrap workspace packages
melos bootstrap

# Execute unit tests across all packages
melos run test

# Run static analysis
melos run analyze
```

---

## License

This project is licensed under the terms of the Apache License 2.0. See [LICENSE](LICENSE) for details.
