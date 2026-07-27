# DiLang Risk Register & Mitigation Matrix

## 1. Risk Evaluation Schema

Risks are categorized by Impact ($1-5$) and Probability ($1-5$), yielding a Risk Score ($R = I \times P$).

---

## 2. Active Technical & Product Risk Log

| Risk ID | Category | Description | Severity (I×P) | Mitigation Strategy |
| :--- | :--- | :--- | :---: | :--- |
| **RSK-01** | Hardware | Local Qwen3-0.6B LLM memory pressure causes OS Out-Of-Memory (OOM) kill on lower-end mobile devices. | $4 \times 3 = 12$ | Dynamic quantization level selection (`Q4_K_M`), lazy unloading of KV cache, and 60-second standby VRAM eviction. |
| **RSK-02** | Speech AI | Whisper STT hallucinated text loops during background silent audio input. | $4 \times 4 = 16$ | Mandatory Voice Activity Detection (VAD) pre-filtering to strip non-speech audio frames prior to inference. |
| **RSK-03** | Performance | Flutter-Rust Bridge string serialization overhead drops frame rates during high-frequency audio streams. | $3 \times 3 = 9$ | Direct zero-copy raw memory pointer sharing via `frb` ZeroCopy byte arrays for PCM audio buffers. |
| **RSK-04** | Algorithmic | FSRS-v4 optimization divergence when user has fewer than 50 review logs. | $3 \times 2 = 6$ | Fall back to default global weight parameters $\mathbf{w}_{\text{default}}$ until review log size exceeds $N \ge 100$. |
| **RSK-05** | Platform | iOS Background App Refresh limits background vector index updates. | $2 \times 4 = 8$ | Defer batch vector index rebuilds to explicit foreground application charging windows. |
