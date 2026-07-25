# DiLang Architecture Constitution

**Version**: 2.0-CONSTITUTIONAL  
**Status**: Highest Engineering Policy (Non-Negotiable)  

---

## 1. Fundamental Principles

1. **One Application**: DiLang is structured as a single, unified Flutter application. Monorepos, microservices, and fragmented package splits are strictly prohibited.
2. **Offline-First by Default**: DiLang operates completely without internet connectivity. Cloud features are optional extensions.
3. **Local-First Data Ownership**: All user data, skill graphs, dialogue transcripts, and cognitive models reside on the user's device.
4. **SQLite is the Only Persistent Datastore**: All structured local state must be stored in the embedded SQLite database (`dilang_storage.db`). No secondary embedded stores (e.g. Hive, Isar, Realm) may be introduced.
5. **Single Public Runtime Orchestrator (`DiLangRuntime`)**: Expose ONE public runtime contract: `DiLangRuntime`. Internally, it coordinates domain managers (`IdentityManager`, `ConversationManager`, `LearningManager`, `SpeechManager`, `SettingsManager`, `DiagnosticsManager`). No feature bypasses `DiLangRuntime`.
6. **Uniform Feature Module Ownership**: Every feature module (`onboarding`, `identity`, `dashboard`, `conversation`, `learning`, `knowledge_graph`, `speech`, `diagnostics`, `settings`) MUST follow the exact same internal directory structure:
   `models/`, `repositories/`, `services/`, `controllers/`, `pages/`, `widgets/`, `dialogs/`, `providers/`.
7. **Decoupled Infrastructure**: Infrastructure components implement abstract interfaces but MUST NEVER import feature modules or presentation code.
8. **No Mock Implementations in Production**: Production code MUST NOT contain mock providers, fake audio pipelines, or fallback data.
9. **Frozen Architecture**: Features adapt to the architecture; the architecture is never modified to accommodate individual feature quirks.

---

## 2. Development Pipeline Rule

> **Every implementation must begin with its contract.**
> 
> 1. **Define the interface.**
> 2. **Define the model.**
> 3. **Write tests.**
> 4. **Implement.**
> 5. **Connect to runtime.**
> 6. **Connect to UI.**
> 
> **Never implement UI first.**

---

## 3. Extended Runtime Rule

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

## 4. Frozen Naming Conventions

### Classes
- Controllers: `IdentityController`, `ConversationController`
- Services: `ConversationService`, `LearningService`
- Contracts: `ReplayRepository`, `IdentityRepository`
- SQLite Implementations: `SqliteReplayRepository`, `SqliteIdentityRepository`
- AI Providers: `OpenAiProvider`, `GeminiProvider`, `LocalLlmProvider`

### Files
- `identity_controller.dart`
- `conversation_service.dart`
- `sqlite_replay_repository.dart`

### Providers
- `identityControllerProvider`
- `conversationServiceProvider`
- `runtimeProvider`

### Tables
- `users`
- `language_profiles`
- `learning_sessions`
- `conversation_turns`
- `knowledge_nodes`
- `fsrs_cards`
- `settings`
