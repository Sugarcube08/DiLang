# DiLang Privacy Architecture & Data Sovereignty Model 🔒📜

> **Notice**: This root document is an alias to the primary privacy specification located at [`docs/architecture/PRIVACY_MODEL.md`](docs/architecture/PRIVACY_MODEL.md).

For full details on privacy-by-design principles, explicit consent boundaries (Microphone, Network, Sync), zero-knowledge cloud sync guarantees, data sensitivity classifications, and atomic local data purge / export mechanisms, please refer directly to:

👉 **[Primary Privacy Model Documentation (`docs/architecture/PRIVACY_MODEL.md`)](docs/architecture/PRIVACY_MODEL.md)**

---

## Privacy Model Summary

- **Charter**: Privacy-by-design & default local sovereignty. Your voice, chat logs, and learning statistics stay on your device.
- **Telemetry**: Zero telemetry, zero analytics, zero remote crash reporting, 100% offline-first.
- **Data Boundaries**: Microphone used strictly for local Whisper STT; network adapter air-gapped unless user explicitly opts into P2P/Relay sync or model downloads.
- **User Rights**: One-click atomic local data purge and universal open exports (JSON, Anki `.apkg`, SQLite dump).
