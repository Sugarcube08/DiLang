# ADR-0006: Local Speech Synthesis via Piper Neural Voice Engine

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
To engage in natural conversational roleplay, the user must hear clear native pronunciation responses. Native OS TTS systems (e.g. Android TextToSpeech, macOS SpeechSynthesizer) sound robotic and lack language-pack consistency.

---

## Decision Drivers
- High audio quality natural neural speech synthesis.
- Fast execution speed (synthesis speed ratio $>5\times$ real-time on CPU).
- Compact ONNX voice model files ($15-40\text{ MB}$ per language voice).

---

## Decision
Adopt **Piper TTS** embedded via ONNX runtime bindings in `crates/dilang_models`. Dynamically swap ONNX voice files based on the active target language profile.

---

## Consequences
### Positive:
- Natural, expressive neural speech synthesis running entirely offline.
- Ultra-low latency audio generation ($<100\text{ms}$).

### Negative:
- Additional storage footprint per target language voice model (~25 MB each).
