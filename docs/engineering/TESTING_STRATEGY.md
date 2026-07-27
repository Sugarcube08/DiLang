# DiLang Testing Strategy & Quality Assurance

## 1. Testing Pyramid Architecture

```
                 / \
                /   \     E2E Benchmarks & Latency (5%)
               /-----\
              / Integration Tests \  (FRB & SQLite) (25%)
             /---------------------\
            /   Unit Tests (Rust &  \  (70%)
           /    Flutter Widgets)     \
          /---------------------------\
```

---

## 2. Unit Testing Layer (70% Target Coverage)

### 2.1 Rust Core (`crates/`)
- Tests mathematically verify algorithm correctness independent of Flutter UI.
- FSRS v4 scheduling equations, tree-sitter AST rules, tokenizer lemma resolution, and SQLite migrations MUST have isolated unit test suites (`cargo test`).

### 2.2 Flutter UI (`apps/dilang_flutter/`)
- Riverpod state providers are tested in isolation using container overrides.
- Widget visual state rendering is verified with mock bridge interfaces.

---

## 3. Integration Testing Layer (25%)

- **Flutter-Rust Bridge Mocking**: Test suite validates that Dart calls correctly serialize across the FRB memory boundary and receive structured Rust responses.
- **Local SQLite In-Memory Suite**: Tests perform atomic transactions against `:memory:` SQLite instances to guarantee schema migrations do not corrupt user data.

---

## 4. End-to-End & Benchmark Suite (5%)

### 4.1 AI Engine Latency Benchmarks
- Benchmark scripts measure inference performance on standard test devices (ARM64 Android, Apple Silicon, x86_64 Linux):
  - **Whisper STT**: Time to transcribe 5-second WAV audio sample ($< 300\text{ms}$).
  - **Qwen3-0.6B LLM**: Time-to-First-Token (TTFT $< 300\text{ms}$) and generation speed ($>25\text{ tokens/sec}$).
  - **Piper TTS**: Time to synthesize 15-word response string ($< 150\text{ms}$).
