# ADR-0005: Local Speech-to-Text via Whisper C++ Bindings

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
Spoken output practice requires fast, highly accurate speech recognition across multiple target languages and accents. Cloud speech STT services (Google Cloud Speech, Whisper API) introduce latency spikes and compromise user voice privacy.

---

## Decision Drivers
- High accuracy across global languages and non-native accents.
- Fast local inference on CPU/GPU hardware ($<250\text{ms}$ for 5-second audio).
- Compact model footprint using GGML quantization (`ggml-base.bin` ~140 MB).

---

## Decision
Integrate **Whisper STT** via **`whisper.cpp`** native C++ bindings in `crates/dilang_models`. Process incoming microphone PCM buffers ($16\text{kHz}$ 32-bit float) through local VAD prior to transcription.

---

## Consequences
### Positive:
- Offline transcription with zero telemetry leakage.
- High multilingual transcription accuracy across A1-C2 learner speech patterns.

### Negative:
- Memory overhead: ~150-300 MB RAM for Whisper weights.
- Susceptible to hallucination loops if silent frames are not pre-filtered with VAD.
