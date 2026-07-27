# DiLang Initial Product Backlog (PBIs)

## 1. Prioritized Sprint Backlog Items

| PBI ID | Title | Target Epic | Points | Priority |
| :--- | :--- | :--- | :---: | :--- |
| **PBI-001** | Implement FSRS-v4 stability & difficulty formulas in Rust | `EP-02` | 8 | P0 - Critical |
| **PBI-002** | Configure SQLite WAL mode & initial schema migrations | `EP-09` | 5 | P0 - Critical |
| **PBI-003** | Set up `flutter_rust_bridge` v2 generator & codegen workflow | `EP-01` | 5 | P0 - Critical |
| **PBI-004** | Build Whisper native C++ binding wrapper in `dilang_models` | `EP-01` | 8 | P0 - Critical |
| **PBI-005** | Build Qwen3-0.6B llama.cpp FFI context loader with mmap | `EP-01` | 13 | P0 - Critical |
| **PBI-006** | Implement Sudachi-RS Japanese & Jieba Chinese tokenizers | `EP-05` | 5 | P1 - Major |
| **PBI-007** | Create Riverpod Flashcard Practice provider state machine | `EP-10` | 5 | P1 - Major |
| **PBI-008** | Implement Tree-Sitter AST parser for French & Spanish syntax | `EP-04` | 8 | P1 - Major |
| **PBI-009** | Build Piper ONNX neural voice audio player channel | `EP-01` | 8 | P1 - Major |
| **PBI-010** | Implement Dark-mode Glassmorphism design token palette in Dart | `EP-10` | 3 | P2 - Minor |

---

## 2. Sample User Story Detail (`PBI-001`)

```markdown
### PBI-001: Implement FSRS-v4 Core Formulas in Rust
**As a** language learner,
**I want** flashcard intervals calculated using the 19-parameter FSRS-v4 memory model,
**So that** my review load is minimized while guaranteeing 90% target retention.

#### Acceptance Criteria:
- Given an active flashcard with Stability S=3.0 and Difficulty D=5.0, when reviewed with rating 'Good' (3), the calculated next stability S' matches the FSRS-v4 reference equation within 1e-4 tolerance.
- Retrievability R is computed as R(t, S) = (1 + t / (9S))^-1.
- Implementation passes all unit test cases in `crates/dilang_fsrs/tests/fsrs_v4_test.rs`.
```
