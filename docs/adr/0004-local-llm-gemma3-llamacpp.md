# ADR-0004: Local LLM Execution via Gemma 3 and llama.cpp

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
To enable offline conversational roleplay and dynamic grammar diagnostics, DiLang requires an intelligent natural language model. Cloud API dependencies violate DiLang's offline-first privacy ethos and introduce subscription costs.

---

## Decision Drivers
- Offline-first execution on consumer GPUs and CPUs.
- Support for state-of-the-art quantized GGUF weights.
- High generation velocity ($>20$ tokens/sec) and low TTFT ($<400\text{ms}$).
- Structural JSON schema output enforcement via GBNF grammars.

---

## Decision
Utilize **Gemma 3 (4B / 27B GGUF)** executed locally via native Rust FFI bindings to **`llama.cpp`** in `crates/dilang_models`. Quantized formats (`Q4_K_M`, `IQ4_XS`) are loaded via mmap to minimize VRAM/RAM footprints.

---

## Consequences
### Positive:
- 100% offline intelligence with zero API latency overhead or external cost.
- Complete data privacy: conversation turns never leave the user's local device.
- Flexible GBNF grammars guarantee valid structured JSON outputs for engine parsing.

### Negative:
- Memory requirement: requires ~3-4 GB RAM on mobile devices for the 4B quantized model.
- Performance depends on underlying target GPU/CPU acceleration capabilities (Metal, Vulkan, OpenCL).
