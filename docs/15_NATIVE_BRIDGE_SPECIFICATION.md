# 15. Native Bridge & C/FFI SDK Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Native Layer

---

## 1. Unified Native SDK Architecture

Rather than maintaining separate platform-specific FFI wrappers per target operating system, DiLang defines a unified native SDK under `native/sdk/`.

```text
native/
└── sdk/
    ├── include/
    │   └── dilang_native_sdk.h    # Single C ABI header file
    ├── src/
    │   ├── llama_adapter.cpp
    │   ├── whisper_adapter.cpp
    │   ├── piper_adapter.cpp
    │   └── sdk_main.cpp
    └── CMakeLists.txt
```

---

## 2. Unified C ABI Header (`dilang_native_sdk.h`)

All native dynamic functions follow explicit thread-safe C calling conventions:

```c
#ifndef DILANG_NATIVE_SDK_H
#define DILANG_NATIVE_SDK_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// SDK Initialization & Platform Detection
int32_t dilang_sdk_init(const char* storage_path);

// LLM C-ABI
typedef void* dilang_llm_handle_t;
dilang_llm_handle_t dilang_llm_load(const char* model_path, int32_t n_ctx, int32_t n_threads, int32_t n_gpu_layers);
int32_t dilang_llm_eval(dilang_llm_handle_t handle, const char* prompt, float temp, float top_p, char* out_buf, int32_t out_buf_len);
void dilang_llm_free(dilang_llm_handle_t handle);

// STT C-ABI
typedef void* dilang_stt_handle_t;
dilang_stt_handle_t dilang_stt_load(const char* model_path);
int32_t dilang_stt_transcribe(dilang_stt_handle_t handle, const int16_t* pcm_samples, int32_t sample_count, char* out_json, int32_t out_json_len);
void dilang_stt_free(dilang_stt_handle_t handle);

#ifdef __cplusplus
}
#endif

#endif // DILANG_NATIVE_SDK_H
```
