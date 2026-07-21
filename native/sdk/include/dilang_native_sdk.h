#ifndef DILANG_NATIVE_SDK_H
#define DILANG_NATIVE_SDK_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/// Initialize the native C++ AI runtime platform
int32_t dilang_native_sdk_init(const char* storage_path);

/// Thread-safe LLM evaluation interface
typedef void* dilang_llm_handle_t;
dilang_llm_handle_t dilang_llm_load(const char* model_path, int32_t n_ctx, int32_t n_threads, int32_t n_gpu_layers);
int32_t dilang_llm_eval(dilang_llm_handle_t handle, const char* prompt, float temp, float top_p, char* out_buf, int32_t out_buf_len);
void dilang_llm_free(dilang_llm_handle_t handle);

/// Thread-safe Speech-to-Text evaluation interface
typedef void* dilang_stt_handle_t;
dilang_stt_handle_t dilang_stt_load(const char* model_path);
int32_t dilang_stt_transcribe(dilang_stt_handle_t handle, const int16_t* pcm_samples, int32_t sample_count, char* out_json, int32_t out_json_len);
void dilang_stt_free(dilang_stt_handle_t handle);

#ifdef __cplusplus
}
#endif

#endif // DILANG_NATIVE_SDK_H
