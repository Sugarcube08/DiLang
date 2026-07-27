# DiLang Offline-First Architecture & Operational Guarantees 📴⚡

> **Notice**: This root document is an alias to the primary offline-first specification located at [`docs/architecture/OFFLINE_FIRST.md`](docs/architecture/OFFLINE_FIRST.md).

For full details on the zero network dependency guarantee, 3-tier dynamic graceful degradation matrix, offline asset bundling strategy, power & thermal resource management, and post-offline CRDT re-synchronization protocols, please refer directly to:

👉 **[Primary Offline-First Documentation (`docs/architecture/OFFLINE_FIRST.md`)](docs/architecture/OFFLINE_FIRST.md)**

---

## Offline-First Summary

- **Guarantee**: 100% core functionality without internet access. Local SQLite DB is single source of truth.
- **Degradation Tiers**: Tier 1 (Full Multimodal AI: Qwen3-0.6B Instruct + Whisper + Piper) -> Tier 2 (Rule-Based Morphological Dictionary) -> Tier 3 (Minimal Offline Flashcard & SRS).
- **Dynamic Asset Manifest**: Managed via `manifest.json` / remote manifest server with multi-mirror failover (HuggingFace, GitHub Releases, Cloudflare CDN) and dynamic SHA-256 calculation. No hardcoded model URLs or SHA-256 strings in source code.
- **Unified 24-Language Support**: Day 1 support for 24 languages across any source/target pair ($24 \times 24 = 576$ matrix). Zero privileged base language.
- **Application-Wide Localization**: Complete UI localization in learner's source language (onboarding, navigation, dialogs, review cards, AI hints, error messages, RTL).
- **Resource Management**: Dynamic thread throttling on battery, 60-second VRAM eviction on standby, and HLC-deferred CRDT sync.
