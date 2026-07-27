# DiLang Epics & Capabilities Catalogue

## 1. Epic Taxonomy

| Epic Code | Epic Title | Primary Scope | Lead Subsystem |
| :--- | :--- | :--- | :--- |
| **EP-01** | Local AI Engine Foundation | Whisper, Qwen3-0.6B Instruct, Piper native integration | `crates/core` |
| **EP-02** | FSRS-v4 Spaced Memory Core | 19-parameter scheduler & optimizer | `crates/dilang_fsrs` |
| **EP-03** | Conversational Roleplay Workbench | FSM scenario engine & dialogue UI | `dilang_conversation` |
| **EP-04** | Grammar Syntax Diagnostics | Tree-Sitter AST parser & rule engine | `dilang_grammar` |
| **EP-05** | Vocabulary & Morphological Engine | Multi-script tokenizer & Zipf list tagger | `dilang_vocab` |
| **EP-06** | Epistemic Memory & Vector DB | HNSW decay vector index & skill graph | `dilang_memory` |
| **EP-07** | Local Analytics & Progress Metrics | Privacy-preserving local metrics | `dilang_analytics` |
| **EP-08** | Plugin & Language Pack System | ZIP archive parser & plugin sandboxing | `dilang_plugin` |
| **EP-09** | Offline-First CRDT Sync Engine | Local storage & P2P sync | `dilang_sqlite` |
| **EP-10** | Accessibility & Multi-Platform UI | Responsive Flutter glass UI & a11y | `apps/dilang_flutter` |

---

## 2. Capabilities Breakdown Sample (EP-01 & EP-02)

### CAP-01.1: Audio Buffer Resampling & VAD
- Converts mic input streams to $16\text{kHz}$ 32-bit mono WAV.
- Applies Voice Activity Detection (VAD) to trim leading/trailing silence before sending to Whisper STT.

### CAP-02.1: Mathematical FSRS Card Scheduling
- Implements retrievability equation $R = (1 + t / (9S))^{-1}$.
- Updates $S$ (stability) and $D$ (difficulty) deterministically upon rating submission.
