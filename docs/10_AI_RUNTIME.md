# 10. Offline AI Native Runtime & C/FFI Infrastructure — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth

---

## 1. Locked Model Zoo & Quantization Specifications

To guarantee reliable execution across low-end mobile devices (2GB RAM headroom) up to high-end desktop workstations, DiLang standardizes on the following exact offline models:

| Role | Engine | Model Name | Format | Quantization | Size | Target Hardware |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Primary Mobile LLM** | `llama.cpp` | Qwen 2.5 0.5B Instruct | GGUF | Q4_K_M | ~390 MB | Mobile / Low-RAM |
| **Universal LLM** | `llama.cpp` | Gemma 3 1B Instruct | GGUF | Q4_K_M | ~820 MB | Universal / Desktop |
| **Speech-to-Text** | `whisper.cpp` | Whisper Base / Multilingual | GGML | Q5_1 | ~145 MB | All Platforms |
| **Text-to-Speech** | `Piper` | Piper Neural Voices | ONNX | FP16 | ~35 MB / voice | All Platforms |
| **Vector Embeddings** | `onnxruntime` | BGE Small v1.5 | ONNX | INT8 | ~67 MB | All Platforms |

---

## 2. Native C ABI Header Specifications

To avoid overhead and complexity, native C++ wrappers expose clean, thread-safe C headers consumed by `dart:ffi`.

### 2.1 Native LLM Wrapper ABI (`dilang_llama_wrapper.h`)

```c
#ifndef DILANG_LLAMA_WRAPPER_H
#define DILANG_LLAMA_WRAPPER_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void* dilang_llama_context_t;

typedef void (*dilang_token_callback_t)(const char* token_str, void* user_data);

dilang_llama_context_t dilang_llama_init(
    const char* model_path,
    int32_t n_ctx,
    int32_t n_threads,
    bool use_gpu
);

int32_t dilang_llama_eval_stream(
    dilang_llama_context_t ctx,
    const char* prompt,
    float temperature,
    float top_p,
    int32_t max_tokens,
    dilang_token_callback_t callback,
    void* user_data
);

void dilang_llama_free(dilang_llama_context_t ctx);

#ifdef __cplusplus
}
#endif

#endif // DILANG_LLAMA_WRAPPER_H
```

---

### 2.2 Native Speech-to-Text ABI (`dilang_whisper_wrapper.h`)

```c
#ifndef DILANG_WHISPER_WRAPPER_H
#define DILANG_WHISPER_WRAPPER_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void* dilang_whisper_context_t;

typedef struct {
    const char* text;
    int64_t start_ms;
    int64_t end_ms;
    float confidence;
} dilang_whisper_segment_t;

dilang_whisper_context_t dilang_whisper_init(const char* model_path);

int32_t dilang_whisper_transcribe_pcm16(
    dilang_whisper_context_t ctx,
    const int16_t* pcm_samples,
    int32_t num_samples,
    const char* language_code,
    dilang_whisper_segment_t** out_segments,
    int32_t* out_count
);

void dilang_whisper_free_segments(dilang_whisper_segment_t* segments, int32_t count);

void dilang_whisper_free(dilang_whisper_context_t ctx);

#ifdef __cplusplus
}
#endif

#endif // DILANG_WHISPER_WRAPPER_H
```

---

## 3. Hardware Acceleration & Platform Backends

- **Linux**: Vulkan / OpenCL / CPU AVX2 acceleration.
- **Windows**: DirectCompute / Vulkan / CUDA acceleration.
- **macOS**: Metal Performance Shaders (MPS) / Accelerate framework.
- **iOS**: Metal Performance Shaders / CoreML runtime.
- **Android**: Vulkan API / Android NNAPI backend.
