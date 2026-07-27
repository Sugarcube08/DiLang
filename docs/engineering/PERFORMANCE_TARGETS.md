# DiLang Performance Targets & Latency SLA

## 1. SLA Performance Matrix

To maintain immediate conversational fluency, DiLang sets strict hard latency thresholds across desktop and mobile hardware tiers.

| Subsystem Component | Target SLA | Hard Ceiling Limit | Measurement Methodology |
| :--- | :--- | :--- | :--- |
| **Whisper STT Audio Transcription** | $< 250\text{ ms}$ | $< 400\text{ ms}$ | 5-sec WAV input buffer |
| **Qwen3-0.6B Time-To-First-Token (TTFT)** | $< 200\text{ ms}$ | $< 350\text{ ms}$ | Local llama.cpp prompt submission |
| **Qwen3-0.6B Token Generation Velocity** | $> 35\text{ tokens/sec}$ | $> 20\text{ tokens/sec}$ | Streaming token output callback |
| **Piper TTS Audio Synthesis** | $< 100\text{ ms}$ | $< 200\text{ ms}$ | 20-word text sentence input |
| **FSRS v4 Next Interval Scheduling** | $< 2\text{ ms}$ | $< 5\text{ ms}$ | Rust memory calculation |
| **SQLite Local Vector Search (HNSW)** | $< 10\text{ ms}$ | $< 25\text{ ms}$ | Top-5 cosine distance search |
| **Flutter Frame Rendering Rate** | 60 / 120 FPS | $> 55\text{ FPS}$ | Flutter Performance Overlay |

---

## 2. Hardware Resource Constraints

- **Peak RAM Footprint**:
  - Without active local LLM: $< 250\text{ MB}$.
  - With Quantized Qwen3-0.6B Instruct Q4_K_M: $< 750\text{ MB}$.
- **Background CPU Idle Usage**: $< 0.5\%$.
- **Storage Footprint**: Core app binary $< 80\text{ MB}$ (excluding local model weights GGUF/ONNX).
