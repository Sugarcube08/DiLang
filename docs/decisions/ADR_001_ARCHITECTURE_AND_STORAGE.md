# ADR 001: Clean Monorepo Architecture, SQLite & FSRS 4.5 Memory Engine

**Date:** 2026-07-22  
**Status:** Approved Architectural Decision Record  
**Context:** DiLang requires offline-first data persistence, strict module decoupling, zero fake placeholders, and mathematically exact spaced repetition memory scheduling.

---

## Decisions Formally Adopted

1. **Melos Monorepo Structure**: Core logic separated into `packages/core`, `language`, `learner`, `memory`, `storage`, `learning_engine`, `conversation`, `application`, `design_system`, `product_ui`.
2. **SQLite Storage Engine**: Production SQLite with `PRAGMA foreign_keys = ON;`, `WAL` mode, schema migrations table (`schema_migrations`), corruption quick check, and secure key store isolation.
3. **FSRS 4.5 Memory Engine**: Mathematical retrievability calculations ($R(t, S) = (1 + 0.2345679 \times \frac{t}{S})^{-1}$) controlling review intervals.
4. **9-Stage Deterministic Bootstrap Pipeline**: Executing Platform → Logging → SQLite → SecureStorage → Repositories → Settings → Identity → Localization → Navigation.
5. **Dashboard Composition Layer**: Immutable `TodayDashboardViewModel` fed by `TodayDashboardUseCase` querying real database repositories.
6. **Five Quality Gates**: Engineering, Pedagogy, AI Quality, Intelligence, and Automated Educational Evaluation.
