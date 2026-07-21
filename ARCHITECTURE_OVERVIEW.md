# Architecture Overview — DiLang

This document provides an entry point into the system design of DiLang. Full architectural specifications are maintained in the [/docs](docs/) directory.

---

## 1. System Design Principles

1. **Clean Architecture Layering**: Clean separation of Domain, Application, Infrastructure, and Presentation layers.
2. **Event-Driven Asynchrony**: Cross-module communication occurs via an append-only Event Store and in-memory Event Bus.
3. **AI Boundary Isolation**: Local LLM and audio engines act purely as capability providers behind strict Dart C/FFI contracts.
4. **Deterministic Learning Engine**: Memory stability, review intervals, and skill mastery calculations are owned by deterministic mathematical engines (FSRS-4.5).

---

## 2. Package Dependency Flow

```text
               +-----------------------+
               |     apps/mobile       |
               |     apps/desktop      |
               +-----------+-----------+
                           |
                           v
               +-----------------------+
               |packages/design_system |
               +-----------+-----------+
                           |
                           v
         +-----------------+-----------------+
         |                                   |
         v                                   v
+------------------+                +------------------+
|packages/memory   |                |packages/storage  |
+--------+---------+                +--------+---------+
         |                                   |
         v                                   v
+------------------+                +------------------+
|packages/learner  |                |packages/ai_runt. |
+--------+---------+                +--------+---------+
         |                                   |
         v                                   v
+------------------+                +------------------+
|packages/language |                |native/shared (C++)|
+--------+---------+                +------------------+
         |
         v
+------------------+
|packages/core     |
+------------------+
```

---

## 3. Detailed Specifications Index

- [System Architecture Specification](docs/02_ARCHITECTURE.md)
- [Domain Models & Learner Graph](docs/07_DOMAIN_MODEL.md)
- [Event Catalog & Protobuf Schemas](docs/08_EVENT_CATALOG.md)
- [Capability & API Contracts](docs/09_API_CONTRACTS.md)
- [Offline AI & Native Runtime](docs/10_AI_RUNTIME.md)
- [Core Platform Specification](docs/11_PLATFORM_FOUNDATION.md)
