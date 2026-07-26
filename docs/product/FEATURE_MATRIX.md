# DiLang Feature Capability Matrix

| Feature Module | Technology | Offline Support | Platform Matrix | Target Version |
| :--- | :--- | :--- | :--- | :--- |
| **Spaced Repetition (FSRS v4)** | `dilang_fsrs` (Rust Core) | 100% Offline | Mobile + Desktop | v0.1.0-alpha |
| **Encrypted Local Storage** | `dilang_sqlite` (SQLCipher) | 100% Offline | Mobile + Desktop | v0.1.0-alpha |
| **Speech-to-Text (STT)** | `Whisper.cpp` (Rust native) | 100% Offline | Mobile + Desktop | v0.2.0 |
| **Text-to-Speech (TTS)** | `Piper ONNX` (Rust native) | 100% Offline | Mobile + Desktop | v0.2.0 |
| **On-Device LLM Dialogue** | `Gemma 3 1B` + `llama.cpp` | 100% Offline | Mobile + Desktop | v0.3.0 |
| **Vector Knowledge Graph** | `sqlite-vec` | 100% Offline | Mobile + Desktop | v0.3.0 |
| **CRDT E2EE Sync** | `Yrs` (Y-CRDT) + Noise_IK | Optional Peer Sync | Mobile + Desktop | v0.4.0 |
| **Dynamic Plugin System** | `Wasmtime` WASM runtime | 100% Offline | Mobile + Desktop | v0.5.0 |
