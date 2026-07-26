# DiLang Performance Targets & Latency SLA

## 1. SLA Performance Matrix

To maintain immediate conversational fluency, DiLang sets strict hard latency thresholds across desktop and mobile hardware tiers.

| Subsystem Component | Target SLA | Hard Ceiling Limit | Measurement Methodology |
| :--- | :--- | :--- | :--- |
| **Whisper STT Audio Transcription** | $< 250\text{ ms}$ | $< 400\text{ ms}$ | 5-sec WAV input buffer |
| **Gemma 3 Time-To-First-Token (TTFT)** | $< 300\text{ ms}$ | $< 500\text{ ms}$ | Local llama.cpp prompt submission |
| **Gemma 3 Token Generation Velocity** | $> 25\text{ tokens/sec}$ | $> 15\text{ tokens/sec}$ | Streaming token output callback |
| **Piper TTS Audio Synthesis** | $< 100\text{ ms}$ | $< 200\text{ ms}$ | 20-word text sentence input |
| **FSRS v4 Next Interval Scheduling** | $< 2\text{ ms}$ | $< 5\text{ ms}$ | Rust memory calculation |
| **SQLite Local Vector Search (HNSW)** | $< 10\text{ ms}$ | $< 25\text{ ms}$ | Top-5 cosine distance search |
| **Flutter Frame Rendering Rate** | 60 / 120 FPS | $> 55\text{ FPS}$ | Flutter Performance Overlay |

---

## 2. Hardware Resource Constraints

- **Peak RAM Footprint**:
  - Without active local LLM: $< 250\text{ MB}$.
  - With Quantized Gemma 3 4B Q4_K_M: $< 3.2\text{ GB}$.
- **Background CPU Idle Usage**: $< 0.5\%$.
- **Storage Footprint**: Core app binary $< 80\text{ MB}$ (excluding local model weights GGUF/ONNX).
