# ADR-0002: Rust Core Engine & flutter_rust_bridge (FRB v2)

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
The DiLang core engine manages complex mathematical operations (FSRS-v4 spaced repetition), AST syntax parsing (Tree-Sitter), native C++ AI model bindings (`llama.cpp`, `whisper.cpp`), local SQLite database management, and HNSW vector indexing. Performing these tasks in Dart would incur garbage collection stalls and CPU performance degradation.

---

## Decision Drivers
- Memory safety and zero-cost abstractions in Rust.
- High performance for mathematical algorithms and vector computations.
- Seamless C/C++ FFI interoperability for local LLM/STT native libraries.
- Typed interop generation via `flutter_rust_bridge` (FRB v2).

---

## Decision
Implement all business logic, database migrations, model orchestration, and cognitive scheduling in a **Rust Workspace (`crates/`)**. Inter-process communication between Dart and Rust will be exclusively managed through generated **`flutter_rust_bridge` v2** asynchronous bindings.

---

## Consequences
### Positive:
- CPU-intensive tasks run in native Rust threads without blocking the Flutter UI loop.
- Memory safety guarantees eliminate buffer overflow and race condition risks.
- Reusable Rust core can be integrated into web (WASM) or server environments if needed.

### Negative:
- Build pipeline complexity increases (requires both `cargo` and `flutter` toolchains).
- Developers must maintain strict domain isolation at the bridge layer.
