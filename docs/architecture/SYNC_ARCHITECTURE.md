# DiLang Local-First Sync & Encryption Architecture 🔄🔒

> **Notice**: This root document is an alias to the primary sync specification located at [`docs/architecture/SYNC_ARCHITECTURE.md`](docs/architecture/SYNC_ARCHITECTURE.md).

For full details on local-first CRDT mechanics (Yrs / Y-CRDT), Hybrid Logical Clocks (HLC), End-to-End Encryption (E2EE) with Noise Protocol and XChaCha20-Poly1305, multi-topology P2P/Cloud sync setups, and offline mutation queues, please refer directly to:

👉 **[Primary Sync Architecture Documentation (`docs/architecture/SYNC_ARCHITECTURE.md`)](docs/architecture/SYNC_ARCHITECTURE.md)**

---

## Sync Architecture Summary

- **Philosophy**: Local-first data sovereignty. Local database is source of truth; network is an optional side-effect.
- **CRDT Engine**: Yrs (Y-CRDT) state vectors with Hybrid Logical Clock (HLC) causality tracking.
- **Encryption**: Noise_IK handshake, XChaCha20-Poly1305 256-bit AEAD cipher, Argon2id master key derivation.
- **Topologies**: Local P2P mesh (mDNS/libp2p/BLE), Zero-Knowledge encrypted Cloud Relay, and Self-Hosted server support.
