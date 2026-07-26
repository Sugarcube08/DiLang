# ADR-0007: Riverpod State Provider Architecture in Flutter

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
The Flutter frontend requires a reactive, testable, and compile-safe state management framework to manage user session states, audio waveform streams, FSRS review queues, and model loading progress.

---

## Decision Drivers
- Compile-time safety and provider isolation.
- Built-in support for asynchronous streams (`AsyncNotifierProvider`).
- Testability without requiring full WidgetTester trees.
- Absence of context-dependent lookup bugs found in legacy Provider.

---

## Decision
Standardize on **Riverpod 2.x** with code generation (`riverpod_generator`) as the mandatory state management architecture for `apps/dilang_flutter`.

---

## Consequences
### Positive:
- Unifies application state management across complex async streams.
- Provider overriding enables straightforward mock testing of FRB Rust bridges.

### Negative:
- Learning curve for code generation syntax (`@riverpod`).
