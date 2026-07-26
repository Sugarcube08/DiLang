# DiLang Offline-First Architecture & Operational Guarantees 📴⚡

> **Notice**: This root document is an alias to the primary offline-first specification located at [`docs/architecture/OFFLINE_FIRST.md`](docs/architecture/OFFLINE_FIRST.md).

For full details on the zero network dependency guarantee, 3-tier dynamic graceful degradation matrix, offline asset bundling strategy, power & thermal resource management, and post-offline CRDT re-synchronization protocols, please refer directly to:

👉 **[Primary Offline-First Documentation (`docs/architecture/OFFLINE_FIRST.md`)](docs/architecture/OFFLINE_FIRST.md)**

---

## Offline-First Summary

- **Guarantee**: 100% core functionality without internet access. Local SQLite DB is single source of truth.
- **Degradation Tiers**: Tier 1 (Full Multimodal AI: Gemma 3 1B + Whisper + Piper) -> Tier 2 (Rule-Based Morphological Dictionary) -> Tier 3 (Minimal Offline Flashcard & SRS).
- **Bundling**: Integrated baseline dictionaries and acoustic speech models; downloadable GGUF LLM weights with SHA-256 validation.
- **Resource Management**: Dynamic thread throttling on battery, 60-second VRAM eviction on standby, and HLC-deferred CRDT sync.
