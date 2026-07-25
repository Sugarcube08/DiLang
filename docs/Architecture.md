# DiLang — Frozen System Architecture & Contracts

**Version**: 2.3-FROZEN  
**Status**: Architecture Phase Closed (Frozen & Authoritative)  

---

## 1. The Extended Runtime Rule

```text
Widget
  ↓
Controller
  ↓
DiLangRuntime (Orchestrator)
  ↓
Service (Business Logic)
  ↓
Repository (Data Access Contract)
  ↓
Infrastructure (Platform Drivers)
  ↓
SQLite / AI / Filesystem
```

---

## 2. Feature Engineering Lifecycle

```text
Select Feature
      │
      ▼
Define Contract
      │
      ▼
Define Models
      │
      ▼
Write Unit Tests
      │
      ▼
Implement Service
      │
      ▼
Implement Repository
      │
      ▼
Wire Through DiLangRuntime
      │
      ▼
Build UI Components
      │
      ▼
Integration Tests
      │
      ▼
Mark Feature Complete (Check DoD)
```

---

## 3. Reordered Implementation Sequence

1. **Design System** – Theme, typography, components, responsive layout, navigation shell.
2. **App Bootstrap** – Dependency injection, runtime initialization, routing.
3. **SQLite Infrastructure** – Database engine, migrations, repository implementations.
4. **Identity Module** – Onboarding, profile creation, persistence, settings.
5. **AI Infrastructure** – Provider abstraction (`LlmProvider`) and prompt pipeline.
6. **Speech Infrastructure** – Hardware STT/TTS audio integration.
7. **Learning Module** – FSRS-4.5 math engine, missions, cognitive model.
8. **Conversation Module** – Dialogue flow, scenario execution, replay transcripts.
9. **Knowledge Graph Module** – Skill DAG visualization and word web persistence.
10. **Dashboard Module** – Data-driven home screen & WHOOP scorecards.
11. **Diagnostics Module** – Runtime logging, performance metrics, debug overlays.
