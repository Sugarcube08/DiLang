# DiLang — Application Runtime Specification

**Version**: 2.1-FROZEN  
**Status**: Frozen & Authoritative  

---

## 1. Application Layer Layout (`lib/app/`)

Application-level initialization, state orchestration, routing, and dependency injection are organized under `lib/app/`:

```text
lib/app/
├── bootstrap/             # App initialization, SQLite database opening, integrity checks
├── runtime/               # DiLangRuntime authoritative state kernel
├── routing/               # Navigation router & screen transitions
└── dependency_injection/  # Riverpod global DI providers
```

---

## 2. The `DiLangRuntime` Kernel

`DiLangRuntime` (`lib/app/runtime/dilang_runtime.dart`) is the single source of truth for application state.

### Managed State Concerns:
- **`learner`**: Active user identity & target language profile.
- **`knowledgeGraph`**: Universal skill DAG.
- **`cognitiveModel`**: Inferred FSRS memory stability & CEFR readiness.
- **`activeScenario` & `activeTurns`**: Active conversation state.
- **`diagnostics`**: Runtime logs, performance metrics, crash reports, debug overlays (Zero user tracking).

---

## 3. The Runtime Rule Flow

```text
Widget ──► Controller ──► Service ──► Repository ──► Infrastructure ──► SQLite / AI / Filesystem
```

Only `DiLangRuntime` updates runtime state snapshots and emits events to `EventBus`. Widgets read state reactively and never execute direct mutations or infrastructure calls.
