# Security Policy — DiLang

## 1. Local & Offline Privacy Focus
DiLang is engineered with a **local-first, privacy-by-default architecture**. Under normal execution:
- Learner progress data remains stored in local SQLite databases.
- AI models run on-device (`llama.cpp`, `whisper.cpp`, `Piper`).
- No user telemetry or voice audio is uploaded to remote servers without explicit user-initiated sync configuration.

## 2. Reporting Vulnerabilities
If you discover a potential security flaw in DiLang (e.g. storage encryption bypass, local FFI memory safety bug), please report it directly to the maintainers via private security disclosure rather than opening a public issue.
