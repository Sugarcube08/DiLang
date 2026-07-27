# DiLang 🌐⚡

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
[![Dual Licensed](https://img.shields.io/badge/Dual_License-Commercial-gold.svg)](LICENSE)
[![Architecture: Local--First](https://img.shields.io/badge/Architecture-Local--First-emerald.svg)](#architecture)
[![Privacy: Zero Telemetry](https://img.shields.io/badge/Privacy-100%25_Offline-purple.svg)](#privacy--security-governance)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Rust](https://img.shields.io/badge/Rust-1.80+-000000?logo=rust)](https://www.rust-lang.org)

**DiLang** is a privacy-first, local-first, offline-first AI-native language learning platform. Built with a high-performance **Rust** engine core and a modern **Flutter** multiplatform UI, DiLang brings state-of-the-art Large Language Models, Speech-to-Text (STT), and Text-to-Speech (TTS) directly to consumer devices without reliance on external cloud APIs or user tracking.

---

## 🌟 Key Features & Philosophy

- 🔒 **100% Offline & Private**: All inference, speech processing, and spaced repetition analytics execute locally. Your conversation logs, voice recordings, and learning history never leave your device.
- 🤖 **On-Device LLM Intelligence**: Powered by quantized **Qwen3-0.6B Instruct (GGUF)** models tailored for contextual grammar explanation, interactive dialogue roleplay, hints, and real-time response generation.
- 🌐 **Deterministic Translation Provider**: Uses SQLite dictionaries, phrase knowledge bases, and morphological analyzers deterministically, using Qwen only as a fallback.
- 🎙️ **On-Device Speech Processing**:
  - **Speech-to-Text (STT)**: High-accuracy streaming transcription via **Whisper.cpp**.
  - **Text-to-Speech (TTS)**: Low-latency neural speech synthesis via **Piper**.
- 🧠 **Local Knowledge Graph & Spaced Repetition**: Dynamic memory engine utilizing **SQLite** and the **Free Spaced Repetition Scheduler (FSRS)** algorithm for optimal vocabulary retention.
- ⚡ **Native Performance**: Multi-threaded Rust backend handles intensive tensor math, SQLite transactions, and audio encoding/decoding while Flutter renders 60/120 FPS UI across mobile and desktop.

---

## 🏗️ High-Level Architecture

DiLang follows a modular, layer-separated architecture linked via zero-copy cross-language bindings powered by `flutter_rust_bridge`.

```text
┌──────────────────────────────────────────────────────────┐
│                   Flutter App UI Layer                   │
│              (Dart / Flutter Material 3 UI)             │
└────────────────────────────┬─────────────────────────────┘
                             │ flutter_rust_bridge (FFI)
┌────────────────────────────▼─────────────────────────────┐
│                    Rust Engine Core                      │
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │    dilang_inference (Qwen3-0.6B, Whisper, Piper)   │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │    dilang_storage  (SQLite, Vector Index, FSRS)    │  │
│  └────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────┐  │
│  │    dilang_sync     (Local-First P2P Sync Engine)   │  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
```

For more details on design decisions and cross-language boundaries, refer to the [ROADMAP.md](ROADMAP.md) and architectural docs.

---

## 📂 Repository Layout

```
DiLang-v2/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── adr_proposal.md
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   ├── workflows/
│   │   └── ci.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── CHANGELOG.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── RELEASE_PROCESS.md
├── ROADMAP.md
├── SECURITY.md
├── VERSIONING.md
└── README.md
```

---

## ⚙️ Prerequisites & Getting Started

### Prerequisites

- **Flutter SDK**: `>= 3.22.0`
- **Rust Toolchain**: `>= 1.80.0` (with `cargo`, `rustfmt`, and `clippy`)
- **flutter_rust_bridge_codegen**: `>= 2.0.0`
- **C/C++ Build Tools**: CMake, Clang/GCC for native model bindings

### Quick Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/dilang-ai/dilang.git
   cd dilang
   ```

2. **Verify Toolchains**:
   ```bash
   flutter doctor
   rustc --version
   ```

3. **Check Code Integrity**:
   ```bash
   # Test Rust core crates
   cargo test --workspace

   # Test Flutter application
   flutter test
   ```

---

## 📜 Governance & License Declaration

DiLang is committed to open governance, software freedom, and long-term economic sustainability.

- **Open Source License**: Free software under the **GNU Affero General Public License v3.0 (AGPLv3)**.
- **Commercial Dual-Licensing**: Commercial licenses are available for enterprise embedding, proprietary forks, or closed-source distributions. See [LICENSE](LICENSE) for full details.
- **Community Governance**: Governance decisions follow open Architectural Decision Records (ADRs). Proposals and technical discussions occur transparently in GitHub Issues and Pull Requests.

---

## 🛡️ Privacy & Security

DiLang operates under a strict **Zero Network Requirement by Default** policy. No telemetry, analytics, remote error tracking, or third-party cloud SDKs are bundled into core releases. For details on security practices, offline model integrity, and reporting vulnerabilities, please consult [SECURITY.md](SECURITY.md).

---

## 🤝 Contributing

We welcome contributions from developers, linguists, UI designers, and AI researchers! Please read [CONTRIBUTING.md](CONTRIBUTING.md) and sign the Developer Certificate of Origin (DCO) before submitting Pull Requests.

---

*DiLang Project — Empowering human language acquisition through private, on-device intelligence.*
