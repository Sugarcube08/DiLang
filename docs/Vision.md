# DiLang — Vision & Core Philosophy

**Version**: 2.0-RESET  
**Status**: Authoritative  

---

## 1. Product Mission
DiLang is an offline-first, local-first, privacy-first, personal **Language Operating System (OS)**. It empowers users to achieve conversational fluency in target languages through interactive AI dialogues, personalized cognitive modeling, and deterministic spaced-repetition math (FSRS-4.5).

---

## 2. Core Non-Negotiables

1. **One Unified Application**: No fragmented package monorepos or REST backends. The application itself is the platform.
2. **Offline-First & Local-First**: All user data, skill graphs, dialogue replays, and cognitive models reside locally in an embedded SQLite database (`dilang_storage.db`).
3. **Privacy-First**: No telemetry, tracking, or cloud data harvesting without explicit user configuration.
4. **Single Authoritative Runtime**: Application state is owned exclusively by `DiLangRuntime`. UI components read state reactively and never execute direct state mutations or raw database queries.
5. **Real AI & Real Speech**: Production AI compute utilizes pluggable providers (Local GGUF/Whisper, Gemini, OpenAI, Claude, Ollama) behind strict interfaces without mock dependencies in production code.
