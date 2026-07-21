#include "dilang_native_sdk.h"
#include <cstring>
#include <cstdlib>

int32_t dilang_native_sdk_init(const char* storage_path) {
    (void)storage_path;
    return 0; // Success
}

dilang_llm_handle_t dilang_llm_load(const char* model_path, int32_t n_ctx, int32_t n_threads, int32_t n_gpu_layers) {
    (void)model_path;
    (void)n_ctx;
    (void)n_threads;
    (void)n_gpu_layers;
    return (dilang_llm_handle_t)1; // Mock handle pointer
}

int32_t dilang_llm_eval(dilang_llm_handle_t handle, const char* prompt, float temp, float top_p, char* out_buf, int32_t out_buf_len) {
    (void)handle;
    (void)prompt;
    (void)temp;
    (void)top_p;
    const char* mock_response = "{\"response\":\"Mock LLM Output\",\"events\":[]}";
    strncpy(out_buf, mock_response, out_buf_len - 1);
    out_buf[out_buf_len - 1] = '\0';
    return (int32_t)strlen(out_buf);
}

void dilang_llm_free(dilang_llm_handle_t handle) {
    (void)handle;
}

dilang_stt_handle_t dilang_stt_load(const char* model_path) {
    (void)model_path;
    return (dilang_stt_handle_t)1;
}

int32_t dilang_stt_transcribe(dilang_stt_handle_t handle, const int16_t* pcm_samples, int32_t sample_count, char* out_json, int32_t out_json_len) {
    (void)handle;
    (void)pcm_samples;
    (void)sample_count;
    const char* mock_stt = "{\"transcription\":\"Mock STT Result\",\"confidence\":0.95}";
    strncpy(out_json, mock_stt, out_json_len - 1);
    out_json[out_json_len - 1] = '\0';
    return (int32_t)strlen(out_json);
}

void dilang_stt_free(dilang_stt_handle_t handle) {
    (void)handle;
}
