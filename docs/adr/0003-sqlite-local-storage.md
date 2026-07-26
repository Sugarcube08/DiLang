# ADR-0003: SQLite Local Storage Architecture with sqlx

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
DiLang requires a robust, local-first structured relational database to store user progress, FSRS card stability parameters, review logs, dialogue transcripts, and curriculum graph nodes across system restarts without network latency.

---

## Decision Drivers
- Zero-configuration local database file portability.
- ACID compliance to prevent user learning state corruption.
- Write-Ahead Logging (WAL) mode support for concurrent read/write access.
- Typed SQL compilation safety in Rust (`sqlx` or `rusqlite`).

---

## Decision
Adopt **SQLite** managed inside `crates/dilang_sqlite` via **`sqlx` / `rusqlite`**. Enable Write-Ahead Logging (`PRAGMA journal_mode = WAL;`) and synchronous normal operations (`PRAGMA synchronous = NORMAL;`). Direct SQLite access from Flutter / Dart is strictly prohibited.

---

## Consequences
### Positive:
- Single `.db` file enables instant local backup, export, and user data migration.
- Ultra-low latency database queries ($< 2\text{ms}$).
- WAL mode allows concurrent background analytics logging while reading cards.

### Negative:
- Schema changes require careful SQL migration scripts (`migrations/`).
