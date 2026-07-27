# Security Policy & Threat Model 🛡️

DiLang is built from the ground up as a **privacy-first, offline-first, local-first platform**. Security and user data protection are non-negotiable architectural mandates.

---

## 🔒 Reporting a Vulnerability

If you discover a security vulnerability, privacy leak, or potential vector for code execution in DiLang, please notify us responsibly.

**Do NOT open a public GitHub issue for security vulnerabilities.**

### Contact Process
1. Email details of the vulnerability to **security@dilang.ai**.
2. Include steps to reproduce, affected platforms (iOS, Android, Desktop), and component involved (Flutter UI, Rust FFI, SQLite storage, inference bindings).
3. We will acknowledge receipt within **48 hours** and provide status updates at least every 5 business days until resolution.
4. Coordinated disclosure: We request a **90-day embargo** from report date before public disclosure to allow maintainers to issue patched release binaries across platforms.

---

## 🏗️ Threat Model & Security Architecture

DiLang's security posture is designed around local-first data isolation and safe native model execution.

```
┌─────────────────────────────────────────────────────────────┐
│                    Sandboxed Flutter UI                    │
└──────────────────────────────┬──────────────────────────────┘
                               │ FFI Boundary (Safe Serialization)
┌──────────────────────────────▼──────────────────────────────┐
│                    Rust Memory Safety Core                  │
│  ┌────────────────────────┐      ┌───────────────────────┐  │
│  │ SHA-256 Model Validation│      │ SQLite AES-256 Storage│  │
│  └───────────┬────────────┘      └───────────────────────┘  │
└──────────────┼──────────────────────────────────────────────┘
               │ Native Execution Containment
┌──────────────▼──────────────────────────────────────────────┐
│  Quantized Inference Engines (Whisper.cpp, Qwen3-0.6B, Piper) │
└─────────────────────────────────────────────────────────────┘
```

### 1. Offline Model & Weight Safety
- **Untrusted Language Packs**: Language packs contain GGUF weights, ONNX models, and SQLite dictionaries. DiLang treats all downloaded or imported language packs as potentially untrusted user inputs.
- **SHA-256 Checksum Enforcement**: Language pack bundles are validated against signed manifest hashes prior to extraction or execution.
- **Model Loader Hardening**: C/C++ inference bindings (`llama.cpp`, `whisper.cpp`, `piper`) are compiled with stack guards, address space layout randomization (ASLR), and buffer overflow protections (`-fstack-protector-strong`, `-D_FORTIFY_SOURCE=2`).

### 2. Local Data Protection & Encryption
- **Encrypted Local Storage**: Personal learning records, flashcard reviews, and AI conversation logs are stored in a local SQLite database protected with **SQLCipher (AES-256-GCM)** encryption at rest.
- **Zero Cloud Telemetry**: Core builds do not contain telemetry SDKs, crash report uploaders, or ad trackers. Outbound network sockets are disabled in core runtime.
- **Microphone & Audio Privacy**: Audio streams captured for STT transcription pass exclusively through local RAM buffers to Whisper.cpp. Audio buffers are overwritten and cleared immediately after inference.

### 3. Cross-Language (FFI) Memory Safety
- **Rust Boundary Isolation**: The Rust engine isolates unsafe C/C++ model bindings from Flutter's Dart VM.
- **Panic Catching**: Native Rust panics are caught at the FFI boundary using `std::panic::catch_unwind` to prevent undefined behavior or application crashes from crashing the host process unsafely.

---

## 🛡️ Supported Versions

| Version | Supported for Security Updates |
| ------- | ------------------------------ |
| v0.1.x  | ✅ Active                     |
| < 0.1.0 | ❌ End of Life                 |

---

## 📜 Compliance & Audits

DiLang undergoes periodic automated vulnerability scanning and open-source dependency auditing via `cargo audit` and `pub outdated` in CI workflows.
