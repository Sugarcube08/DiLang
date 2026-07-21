# 06. System Memory & Architectural Decision Records (ADRs) — DiLang

**Document Version:** 1.0.0  
**Status:** Active Living Document

---

## 1. Architectural Decision Records (ADRs)

### ADR-001: Dynamic Dual-Storage Architecture (Event Sourcing + Relational Projections)
- **Status:** Accepted  
- **Context:** DiLang requires deterministic learner tracking, exact history replayability, and local-first sync capabilities. Traditional CRUD databases obscure state mutation history and make conflict-free offline sync difficult.
- **Decision:** Adopt Event Sourcing. All user actions and learning events are stored in an append-only `domain_event_store` SQLite table. Relational tables in SQLite/Drift serve as read projections updated via event handlers.
- **Consequences:** Replayability guaranteed; LLM predictions cannot corrupt state; sync can be performed by exchanging missing event blocks. Higher initial development setup cost for event handlers.

### ADR-002: Dynamic Dynamic C/FFI Bindings for Native AI Frameworks
- **Status:** Accepted  
- **Context:** High performance LLM, STT, and TTS execution requires direct C++ library interaction without high-overhead IPC mechanisms or network hops.
- **Decision:** Bind directly to `llama.cpp`, `whisper.cpp`, and `Piper` using Dart C/FFI (`dart:ffi`). Native wrappers will expose simple thread-safe C ABIs (`dilang_llama_init`, `dilang_llama_eval`, etc.).
- **Consequences:** Near-zero latency execution and native GPU/NPU acceleration. Requires maintaining native C++ CMake build scripts per platform.

### ADR-003: FSRS-4.5 Algorithm over Spaced Repetition Alternatives
- **Status:** Accepted  
- **Context:** Legacy SM-2 algorithms do not account for memory stability, retrievability, or item difficulty effectively under modern cognitive modeling research.
- **Decision:** Standardize on FSRS-4.5 (Free Spaced Repetition Scheduler) as the core memory algorithm in the Learner Graph Context.
- **Consequences:** Higher memory retention rates, reduced redundant reviews, deterministic mathematical formula independent of LLMs.

---

## 2. Completed Milestones & System State Log

| Milestone ID | Description | Status | Verification Date |
| :--- | :--- | :--- | :--- |
| `M0.1` | Initializing Documentation Suite (`01` - `10`) | **Completed** | 2026-07-22 |
| `M0.2` | Protobuf Schema Contracts Declaration | Pending | Phase 1 |
| `M0.3` | Native C/FFI Stub Wrappers Setup | Pending | Phase 2 |
| `M0.4` | Drift EventStore & Projection Engine | Pending | Phase 3 |

---

## 3. Active System State

- **Current Active Phase:** Phase 1 (Contract Specification & Core Abstractions)
- **Active Technical Focus:** Standardizing Domain Models, Event Catalog, Capability Interfaces, and API Contracts across `docs/07` to `docs/10`.
