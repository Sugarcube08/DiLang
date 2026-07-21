# 03. Development & Architectural Rules — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Non-Negotiable Rules

---

## 1. Non-Negotiable Core Directives

### Rule 1: Contract-First Development
No application feature, UI widget, database table, or module implementation may be written until its public contracts (Interfaces, Entities, Domain Events, Protobuf messages) have been formally declared and reviewed in `/docs`.

### Rule 2: LLM Boundary Isolation
Artificial Intelligence models (LLMs, Whisper, Piper) are pure infrastructure providers. Under **no circumstances** may an LLM response directly mutate database state, alter a user's mastery score, or dictate exercise progression. All LLM outputs must pass through deterministic domain parsers and emit domain events evaluated by the Learning Engine.

### Rule 3: Module Decoupling & Event Communication
No domain module may directly import or instantiate services from another domain module. Cross-module data transfer occurs **exclusively via the Event Bus** using immutable domain event objects.
- *Forbidden:* `VocabularyRepository.updateFromConversation(...)`
- *Mandatory:* `ConversationModule` emits `ConversationFinishedEvent` $\rightarrow$ `VocabularyModule` listens and schedules vocabulary extraction jobs.

### Rule 4: Absolute Offline Independence
Every feature must function 100% offline. Network interfaces (gRPC) are optional local-first sync conduits and cloud backups. Zero telemetry or authentication calls may block local app startup or learning interactions.

---

## 2. Code Quality & Language Standards

### 2.1 Dart & Flutter Best Practices
- **Strict Typing**: `implicit-casts: false` and `implicit-dynamic: false` enabled in `analysis_options.yaml`. `dynamic` type is strictly banned across the codebase.
- **Null Safety**: 100% sound null safety. Force unwrapping (`!`) is strictly forbidden except in verified test suites.
- **State Management**: Use `flutter_riverpod` with `@riverpod` annotations (Riverpod 2.x generator). State classes must be immutable (`@freezed` or `meta` `@immutable`).
- **Immutability**: Domain models and event classes must be immutable using `Freezed` or `equatable`.

### 2.2 Project Directory Structure
All modules must strictly adhere to the following Clean Architecture directory format:

```text
lib/src/modules/<module_name>/
├── domain/
│   ├── entities/
│   ├── value_objects/
│   ├── events/
│   ├── repositories/       # Abstract interface contracts ONLY
│   └── failure/
├── application/
│   ├── usecases/
│   ├── dtos/
│   └── services/
├── infrastructure/
│   ├── datasources/
│   ├── repositories/       # Concrete Drift / FFI implementations
│   ├── mappers/
│   └── dtos/
└── presentation/
    ├── controllers/        # Riverpod Notifiers
    ├── widgets/
    └── screens/
```

---

## 3. Storage & Event Sourcing Directives

1. **Immutable Event Log**: Table `domain_event_store` in SQLite is append-only. No `UPDATE` or `DELETE` queries may be executed against event records.
2. **Deterministic Projections**: Drift read tables are projections generated from event stream processing. Re-building a database projection must produce identical state every time.
3. **Database Migration Safety**: Schema modifications must include explicit SQL upgrade scripts and Drift schema validation tests.

---

## 4. Hardware & Resource Usage Rules

- Maximum allowed background memory during passive standby: `< 150MB`.
- Maximum peak RAM during local LLM + Whisper inference: `< 800MB` on mobile, `< 2.5GB` on desktop.
- Audio sampling standard across STT/TTS: `16kHz, 16-bit mono PCM`.
