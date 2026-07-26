# ADR-0010: Epistemic Local Knowledge Graph & Vector Store

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
To select contextual dialogue scenarios and dynamic prompts tailored to the user's current knowledge frontier, DiLang must query the user's known vocabulary, grammar rules, and past dialogue turns using semantic similarity.

---

## Decision Drivers
- Fast semantic vector similarity search ($<10\text{ms}$).
- Graph traversal of prerequisite dependencies between CEFR concepts.
- Memory efficiency on consumer devices.

---

## Decision
Implement a **Local Epistemic Memory System** combining an SQLite Directed Acyclic Graph (DAG) for skill prerequisites and a native **HNSW (Hierarchical Navigable Small World)** vector index in Rust using local 384-dimensional sentence embeddings.

---

## Consequences
### Positive:
- Highly relevant, personalized Gemma 3 dialogue prompts derived from user memory state.
- Real-time visual visualization of the user's skill mastery tree.

### Negative:
- Local embedding generation requires lightweight vector model execution (~80 MB RAM).
