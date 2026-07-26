# DiLang Security Model & Threat Specification 🛡️

> **Notice**: This root document is an alias to the primary security model specification located at [`docs/architecture/SECURITY_MODEL.md`](docs/architecture/SECURITY_MODEL.md).

For full details on the STRIDE threat matrix, SQLCipher AES-256-GCM storage security, Argon2id key derivation, OS Secure Keyring integration, Rust `zeroize` memory scrubbing, and supply-chain auditing (`cargo-audit`, `cargo-deny`), please refer directly to:

👉 **[Primary Security Model Documentation (`docs/architecture/SECURITY_MODEL.md`)](docs/architecture/SECURITY_MODEL.md)**

---

## Security Model Summary

- **Principles**: Zero data leakage, zero telemetry by default, hard WASM sandbox, cryptographic data integrity.
- **Threat Mitigation**: STRIDE framework analysis covering Spoofing, Tampering, Information Disclosure, and DoS.
- **Data-at-Rest**: SQLCipher AES-256-GCM encryption with Argon2id key derivation and `zeroize` memory scrubbing.
- **Supply Chain**: Dependency lockfile pinning, `cargo-audit` CVE checks, and license verification (`cargo-deny`).
