# 14. AI Runtime & Compute Platform Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Infrastructure Layer

---

## 1. Overview & Inference Platform Architecture

The AI Runtime in DiLang is designed as an **Inference Platform**, not merely a collection of wrapper functions. It operates independently of higher-level domain context modules (such as Conversation or Assessment) and manages the execution of local AI models (`llama.cpp`, `whisper.cpp`, `Piper`, `BGE Small`).

```
 +-------------------------------------------------------------------------+
 |                           INFERENCE PIPELINE                            |
 | Audio -> STT -> Normalizer -> Tokenizer -> PromptBuilder -> LLM -> JSON |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 |                            RESOURCE SCHEDULER                           |
 | VRAM / RAM Budgeting | GPU Layers | CPU Threads | Thermal Throttle     |
 +------------------------------------+------------------------------------+
                                      |
                                      v
 +-------------------------------------------------------------------------+
 |                        NATIVE RUNTIME SDK (C/FFI)                       |
 | NativeLoader -> libdilang_sdk.so / dll / dylib -> llama / whisper       |
 +-------------------------------------------------------------------------+
```

---

## 2. Resource Scheduler Specification

The `ResourceScheduler` evaluates hardware metrics before allocating VRAM or spawning C++ worker threads:

| Constraint Metric | Low-Power Mobile | Desktop Workstation | Action on Threshold Exceeded |
| :--- | :--- | :--- | :--- |
| **Max RAM Footprint** | `< 800 MB` | `< 4 GB` | Unload passive models / fallback to CPU |
| **Max Context Size** | 2048 tokens | 8192 tokens | Truncate prompt context section |
| **GPU Layers (`n_gpu_layers`)** | Auto-detect (Metal/Vulkan) | Full offload | Fallback to CPU AVX2 |
| **Thread Count (`n_threads`)** | $N_{physical\_cores} - 1$ | $N_{physical\_cores}$ | Reduce thread count under thermal throttling |

---

## 3. Structured Prompt Engine & Output Validation

Prompts are never built using raw string concatenation. They are constructed deterministically using section blocks:

```
PromptTemplate
 ├── SystemSection (Role, Persona, Rules)
 ├── ContextSection (CEFR Level, Target Language)
 ├── MemorySection (Learner Graph state, FSRS history)
 ├── ExamplesSection (Few-shot JSON examples)
 └── UserInputSection (Learner input)
```

Every inference task must return a validated `StructuredOutput` containing both the raw text string and parsed JSON domain entities (events, extracted vocabulary, grammar errors).
