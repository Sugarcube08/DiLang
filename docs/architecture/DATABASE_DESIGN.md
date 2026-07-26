# DiLang Database & Storage Architecture 💾

> **Notice**: This root document is an alias to the primary database design specification located at [`docs/architecture/DATABASE_DESIGN.md`](docs/architecture/DATABASE_DESIGN.md).

For full details on SQLCipher AES-256-GCM encryption, `sqlite-vec` virtual table definitions, complete SQL DDL schemas (users, FSRS flashcards, conversation messages, vector embeddings, CRDT clocks), indexes, and migration pipelines, please refer directly to:

👉 **[Primary Database Design Documentation (`docs/architecture/DATABASE_DESIGN.md`)](docs/architecture/DATABASE_DESIGN.md)**

---

## Storage Summary Overview

- **Engine**: SQLite 3.x with SQLCipher AES-256-GCM full-database encryption at rest.
- **Vector Search**: `sqlite-vec` 384d cosine distance virtual tables for semantic retrieval.
- **Flashcard Engine**: FSRS v5 (Stability, Difficulty, Retrievability, Elapsed/Scheduled Days, Reps, Lapses).
- **Migration System**: Rust-managed `refinery` atomic transaction migrations with zero downtime key rotation.
