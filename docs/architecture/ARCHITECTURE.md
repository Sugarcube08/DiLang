# DiLang Architecture Specification (v2.0 Frozen)

> **GOVERNANCE DECLARATION**: Architecture Freeze v2.0 is officially **FROZEN**. All application runtime, repository contracts, transactional caching policies, dependency injection containers, and event bus taxonomies are strictly locked prior to AI model runtime integration.

---

## 1. Layered Architecture (4-Tier Separation of Concerns)

```text
┌─────────────────────────────────────────────────────────┐
│                       Flutter UI                        │
│   Pages • Atomic Components • Dialogs • Glass Panels    │
└────────────────────────────┬────────────────────────────┘
                             │
                      ViewModel Layer
              (Riverpod AsyncNotifiers & Controllers)
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                    Repository Layer                     │
│  ConversationRepo • VocabRepo • ReviewRepo • SyncRepo   │
└────────────────────────────┬────────────────────────────┘
                             │
                       FFI Bridge Layer
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                    Rust Public API                      │
│   initialize() • conversation_reply() • review_next()   │
└────────────────────────────┬────────────────────────────┘
                             │
                       Rust Core Engines
            (Storage • EventBus • Workers • Models)
```

### Architectural Enforcement Rules
1. **UI Layer Isolation**: Flutter UI widgets never consume FFI bridge functions directly. All interactions flow through Riverpod Notifiers and Repository abstractions.
2. **Repository Ownership**: Repositories own memory caching, SQLite queries, local transaction boundaries, and FFI orchestration.
3. **Rust Engine Independence**: Rust engines (`dilang_core`) operate completely decoupled from Dart/Flutter.
4. **Event-Driven Communication**: Subsystem cross-talk operates strictly via published events over the thread-safe `EventBus`.

---

## 2. Event Bus & Event Architecture (Phase 4)

Every system event is immutable and conforms to the standard payload header:

```rust
pub struct EventHeader {
    pub id: String,
    pub timestamp: DateTime<Utc>,
    pub session_id: String,
    pub user_id: String,
    pub source: String,
    pub version: u32,
}
```

### Event Taxonomy
- **Conversation**: `ConversationStarted`, `ConversationEnded`, `MessageReceived`, `MessageGenerated`, `CorrectionGenerated`
- **Vocabulary**: `VocabularyDetected`, `VocabularyMastered`, `VocabularyForgotten`, `VocabularyReviewed`
- **Grammar**: `GrammarDetected`, `GrammarWeaknessFound`, `GrammarMastered`
- **Review**: `ReviewScheduled`, `ReviewStarted`, `ReviewCompleted`, `ReviewSkipped`
- **Analytics**: `ProgressUpdated`, `DashboardChanged`, `CEFRUpdated`, `LearningSessionEnded`
- **System**: `AppStarted`, `AppStopped`, `SettingsChanged`, `LanguageChanged`, `ProviderLoaded`, `ProviderFailed`
