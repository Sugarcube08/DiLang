# DiLang — Frozen System Architecture & Contracts

**Version**: 2.2-FROZEN  
**Status**: Frozen & Authoritative  

---

## 1. The Extended Runtime Rule

```text
Widget
  ↓
Controller
  ↓
Runtime (Orchestrator)
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

## 2. Frozen Public Contracts Index

### Runtime Interfaces
- `IdentityRuntime`
- `ConversationRuntime`
- `LearningRuntime`
- `SpeechRuntime`
- `SettingsRuntime`
- `DiagnosticsRuntime`

### Repository Contracts
- `IdentityRepository`
- `ReplayRepository`
- `KnowledgeGraphRepository`
- `SettingsRepository`
- `FsrsRepository`

### Infrastructure Contracts
- `LlmProvider`
- `SttProvider`
- `TtsProvider`
- `SecureStorage`
- `DatabaseEngine`

---

## 3. Implementation Sequence

1. **Design System** – Theme, typography, components, responsive layout, navigation shell.
2. **App Bootstrap** – Dependency injection, runtime initialization, routing.
3. **SQLite Infrastructure** – Database engine, migrations, repository implementations.
4. **Identity Module** – Onboarding, profile creation, persistence, settings.
5. **Dashboard Module** – Runtime-driven home screen.
6. **Learning Module** – FSRS, missions, learner state.
7. **Conversation Module** – Dialogue flow and replay.
8. **Knowledge Graph Module** – Visualization and persistence.
9. **Speech Infrastructure** – STT/TTS integration.
10. **AI Infrastructure** – Provider abstraction and prompt pipeline.
11. **Diagnostics Module** – Logging, performance, crash reporting.
