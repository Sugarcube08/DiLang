# DiLang User Story Mapping & Release Slices

## 1. User Journey Backbone

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Onboarding &   │ ─► │  Daily Memory   │ ─► │  Conversational │ ─► │  Progress &     │
│  Model Setup    │    │  Card Practice  │    │  Voice Roleplay │    │  Skill Tree     │
└────────┬────────┘    └────────┬────────┘    └────────┬────────┘    └────────┬────────┘
         │                      │                      │                      │
         ▼                      ▼                      ▼                      ▼
  [ Release Slices ]     [ Release Slices ]     [ Release Slices ]     [ Release Slices ]
```

---

## 2. Release Slices

### Slice 1: V0.1 MVP (Core Practice Engine)
- Local model weight downloader & mmap loader.
- Basic text-based FSRS flashcard review interface.
- Local SQLite database storage.

### Slice 2: V0.5 Alpha (Voice & AI Roleplay)
- Whisper voice transcription & Piper speech synthesis.
- Qwen3-0.6B local dialogue roleplay scenarios.
- Grammar error inline annotations.

### Slice 3: V1.0 Production Release
- Full Epistemic Memory Vector Store.
- Language Pack plugin manager.
- Multi-device P2P offline sync.
