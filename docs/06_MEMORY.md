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

### ADR-008: Formal Platform Architecture Freeze (v2.0 Platform Release)
- **Status:** Accepted  
- **Context:** The DiLang platform infrastructure (Core Kernel, Language, Learner, Memory, AI Runtime, Storage Contracts, Sync Engine, Learning Engine, Conversation Engine, Application Layer, Design System, Mobile/Desktop entrypoints, and Extension SDK) is feature-complete across 41 source-of-truth specification contracts. Continuing to modify foundational contracts risks architectural churn.
- **Decision:** Formally freeze the platform architecture under the `release/v2.x` maintenance branch. Foundational package boundaries, dependency graphs, and public API contracts are locked. All future v2.x iterations transition strictly to product engineering, content curation, model tuning, UX refinement, and empirical learning outcome validation.
- **Consequences:** Platform maintainability guaranteed. Future architectural mutations require formal ADR proposals and are reserved for the v3.0 strategic research horizon.

---

## 2. Completed Milestones & System State Log

| Milestone ID | Description | Status | Verification Date |
| :--- | :--- | :--- | :--- |
| `M0.1` | Initializing Documentation Suite (`01` - `10`) | **Completed** | 2026-07-22 |
| `M1.0` | Core Platform Foundation & Governance (`v1.0.0-phase.2`) | **Completed** | 2026-07-22 |
| `M2.0` | AI Compute Platform & Native SDK (`v1.0.0-phase.3`) | **Completed** | 2026-07-22 |
| `M3.0` | Persistence & Event Replication Engine (`v1.0.0-phase.4`) | **Completed** | 2026-07-22 |
| `M4.0` | Deterministic Learning & Assessment Platform (`v1.0.0-phase.5`) | **Completed** | 2026-07-22 |
| `M5.0` | Conversation Engine & Multimodal Application Platform (`v2.0.0`) | **Completed** | 2026-07-22 |

---

## 3. Active System State

- **Current Active Branch:** `release/v2.x` (Architecture Frozen)
- **Active Technical Focus:** Product Engineering, CEFR Content Aggregation, Local Model Tuning, UX Polish, and Empirical Educational Validation.
