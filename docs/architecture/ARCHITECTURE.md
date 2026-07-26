# DiLang Architecture Specification (v3.0 Frozen)

> **GOVERNANCE DECLARATION**: Architecture Freeze v3.0 (Phase 5 Infrastructure Layer) is officially **FROZEN**. All error models (`AppError`), result aliases (`CoreResult<T>`), configuration managers (`ConfigManager`), model managers (`ModelManager`), resource managers (`ResourceManager`), task schedulers (`Scheduler`), capability registries (`CapabilityRegistry`), and feature flag systems are locked prior to feature engine implementations.

---

## 1. Complete System Architecture Stack

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
                             │
─────────────────────────────┴────────────────────────────
                Infrastructure Layer (Shared Base)
  ConfigManager • AppError • CoreResult<T> • Scheduler
  ModelManager • ResourceManager • CapabilityRegistry
  Internal Metrics • Structured Logger • FeatureFlags
──────────────────────────────────────────────────────────
```

---

## 2. Phase 5 Infrastructure Specifications

### 2.1 Error Hierarchy (`AppError`)
Centralized typed error handling across all sub-crates:
- `StorageError`, `ConversationError`, `ReviewError`, `SyncError`, `AIError`, `ProviderError`, `ConfigError`, `InternalError`.
- Includes error code, severity level (Info, Warning, Error, Fatal), recoverability flag, user-facing message, and developer context.

### 2.2 Global Result Alias (`CoreResult<T>`)
- `pub type CoreResult<T> = Result<T, AppError>;`

### 2.3 Model Manager (`ModelManager`)
- Handles model location, SHA-256 integrity verification, memory loading/unloading, VRAM budget allocation, and version compatibility.

### 2.4 Capability Registry (`CapabilityRegistry`)
- Decouples feature queries from concrete providers. Modules query capabilities (`Capability::Conversation`, `Capability::SpeechToText`, `Capability::TextToSpeech`) rather than hardcoding vendor runtimes.
