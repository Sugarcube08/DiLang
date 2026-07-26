# ADR-0011: Adopt Free Spaced Repetition Scheduler v4 (FSRS-v4)

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
Legacy spaced repetition algorithms like SuperMemo 2 (SM-2) rely on crude static multiplier heuristics (e.g. $2.5\times$ interval expansion) that fail to accurately model human memory decay, resulting in either over-reviewing or under-retention.

---

## Decision Drivers
- State-of-the-art mathematical accuracy in memory modeling (90%+ retention target optimization).
- Parameterized memory Stability ($S$) and Difficulty ($D$) states.
- Local weight optimization capability via gradient descent over historical review logs.

---

## Decision
Adopt **FSRS-v4 (Free Spaced Repetition Scheduler v4.5)** implemented natively in Rust (`crates/dilang_fsrs`). Deprecate all SM-2 heuristic legacy code paths.

---

## Consequences
### Positive:
- Reduces review load by 20-30% compared to SM-2 while maintaining or exceeding target retention rates.
- Local optimization tailors 19 parameter weights to individual user memory profiles.

### Negative:
- Requires mathematical rigor and test coverage for stability decay equations.
