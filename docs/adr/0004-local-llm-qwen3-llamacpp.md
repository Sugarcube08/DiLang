# ADR-0004: Local LLM Execution via Qwen3-0.6B Instruct and llama.cpp

## Status
🟢 **ACCEPTED** (2026-07-28)

---

## Context & Problem Statement
To enable offline conversational roleplay, hint generation, adaptive dialogue, and explanations, DiLang requires an intelligent, highly-capable natural language model with strong instruction-following and multilingual performance at a low memory footprint. Cloud API dependencies violate DiLang's offline-first privacy ethos and introduce subscription costs.

---

## Decision Drivers
- Offline-first execution on consumer GPUs and CPUs.
- Support for state-of-the-art quantized GGUF weights (`Q4_K_M`).
- High generation velocity ($>25$ tokens/sec) and low TTFT ($<300\text{ms}$).
- Superior multilingual capability and instruction following at edge footprint (~450MB RAM).
- Clear separation of responsibilities: Qwen3-0.6B handles conversation, chat, roleplay, explanations, hints, and adaptive responses, while deterministic Rust engines handle translation, vocabulary scheduling, morphology, and CEFR calculation.

---

## Decision
Utilize **Qwen3-0.6B Instruct (GGUF)** executed locally via native Rust FFI bindings to **`llama.cpp`** as the primary Conversation Provider. Quantized formats (`Q4_K_M`) are loaded via mmap to minimize VRAM/RAM footprints.

---

## Consequences
### Positive:
- 100% offline intelligence with minimal RAM overhead (~450MB).
- Superior multilingual support across target learning languages.
- Complete data privacy: conversation turns never leave the user's local device.
- Stateless model design decoupled from deterministic learning and translation engines.

### Negative:
- Performance depends on underlying target GPU/CPU acceleration capabilities (Metal, Vulkan, OpenCL).
