# 62. DiLang Production Rules & Engineering Standards (Phase 0)

**Document Version:** 1.0.0  
**Status:** Approved Master Engineering Contract & Production Rules  
**Scope:** Repository-wide non-negotiables for all packages, features, UI, and data layers.

---

# Part 1 — The 7 Production Rules

These rules govern all architectural, design, state, UI, and backend work across DiLang. Zero exceptions.

---

## Production Rule #1 — Zero Placeholder Policy
> **If it won't exist in the final product, we don't build it.**

- **No fake repositories**, no mock APIs, no placeholder models, no dummy services, no simulated health values, and no temporary `TODO` implementations.
- If a service or feature is not yet ready, the UI must gracefully reflect **"Not Available Yet"** or disable the feature with clean state feedback rather than fabricating fake data.

---

## Production Rule #2 — Full Vertical Feature Completeness
> **Every feature must be complete across the entire stack before marked finished.**

A feature is defined vertically, not horizontally. A feature (e.g. *Language Health*) is not complete until all 11 layers exist and pass verification:

```
[ Domain Model ]
       │
       ▼
[ Business Logic ]
       │
       ▼
[ Persistence (Drift / Local DB) ]
       │
       ▼
[ API / Repository Contract ]
       │
       ▼
[ State Management (Riverpod) ]
       │
       ▼
[ UI Components ]
       │
       ▼
[ Motion & Animations ]
       │
       ▼
[ Accessibility (Semantics / Screen Reader) ]
       │
       ▼
[ Automated Tests (Unit / Golden / Integration) ]
       │
       ▼
[ Documentation ]
       │
       ▼
[ Telemetry & Observability ]
```

---

## Production Rule #3 — Zero Orphan Code
> **Every class, asset, route, provider, and service must be actively referenced and consumed.**

- **Classes**: No dead code or orphaned domain entities.
- **Assets**: No unreferenced PNG/SVG/audio/Lottie files in `pubspec.yaml`.
- **Routes**: Every defined screen route must be reachable through active navigation paths.
- **Providers**: Every Riverpod provider must be consumed by active UI widgets or parent services.
- **Services**: Every service interface must have a production-ready implementation.

---

## Production Rule #4 — Design Pipeline Enforcement
> **Every screen must pass sequentially through the 10-step design-to-release pipeline.**

```
1. UX Specification
       │
2. Interaction Specification
       │
3. Component Breakdown
       │
4. State Machine Definition (FSM)
       │
5. Responsive Layout Blueprint
       │
6. Accessibility Review
       │
7. Implementation (Flutter Widgets)
       │
8. Automated & Manual Testing
       │
9. Performance Profiling
       │
10. Releasable Status
```

No skipping steps. Coding widgets happens only at Step 7.

---

## Production Rule #5 — Production-Quality Data Schemas from Day One
> **Data structures must be fully fleshed out to production specifications immediately.**

Domain entities (e.g. `VocabularyEntry`, `LanguageHealth`, `User`) must never start as simple key-value stubs. They must contain complete metadata, relationships, frequency ranks, CEFR bands, memory decay matrices, and IPA phonetic attributes from their initial definition.

---

## Production Rule #6 — Pure Production State Sourcing
> **Every screen must consume state from real Riverpod providers wired to real persistence.**

```
[ UI Widget ] ──▶ [ Riverpod Provider ] ──▶ [ Repository ] ──▶ [ Drift/SQLite DB ] ──▶ [ Domain Models ]
```

**Forbidden Patterns**:
- `List.generate(...)` for UI mocking.
- Hardcoded constants representing runtime state (e.g., `final progress = 82;`).
- In-memory mock repositories pretending to be database tables.

---

## Production Rule #7 — Objective & Measurable Quality Budgets
> **Quality criteria are quantitative and mandatory for every release.**

- **First Paint / Render**: `< 300 ms` on baseline mobile hardware.
- **Frame Rate**: `60 FPS` locked (no jank during animations or scrolling).
- **Layout Integrity**: Zero layout overflow bugs across supported screen width ranges (`320px` to `3840px`).
- **Accessibility**: 100% semantic screen reader coverage and keyboard navigation support.
- **Code Quality**: Zero analyzer warnings or linter errors under strict Flutter analysis rules.

---

# Part 2 — Phase 0 Foundation Plan

To uphold these rules, we establish Phase 0 across 4 sequential foundation sprints:

```
[ Sprint 0.1: Engineering Standards ] 
                 │
                 ▼
[ Sprint 0.2: Data Contracts & Frozen Domain Schemas ]
                 │
                 ▼
[ Sprint 0.3: Design System Package (`dilang_design_system`) ]
                 │
                 ▼
[ Sprint 0.4: Today Dashboard Detailed Specification ]
```

---

## Sprint 0.1 — Engineering Standards Specification
Freezing all repository-wide architectural conventions:
- **Package Architecture**: Melos monorepo structure (`packages/core`, `packages/design_system`, `packages/storage`, `packages/learning_engine`, etc.).
- **State Management**: Riverpod 2.x `@riverpod` code-generated immutable state notifiers.
- **Database Strategy**: Drift SQLite with strict relational schemas, migrations, and event log append-only table (`domain_event_store`).
- **Error Handling**: `Result<T, Exception>` monads / `Either<Failure, Success>` with zero silent try/catch blocks.

---

## Sprint 0.2 — Freeze Core Data Contracts
Freezing production domain schemas before UI code is written:
1. `User` & `DiLangID`
2. `LearningProfile` & `TargetLanguage`
3. `VocabularyEntry` (lemma, IPA, CEFR, frequency, conjugations, memory decay curve, relationships)
4. `GrammarRule` & `PatternDrill`
5. `ReviewSession` & `FSRS45Parameters`
6. `ConversationSession` & `DialogueTurn`
7. `LanguageHealthMetrics` (8-axis sub-scores, recovery index, stability)
8. `TimelineEvent` & `DailyMission`
9. `AIModelMetadata` & `SyncState`

---

## Sprint 0.3 — Design System Implementation (`packages/design_system`)
Building production design tokens and atomic base components:
- Color Tokens (Dark & Light mode HSL palettes, glass surface opacity)
- Typography Tokens (Inter & JetBrains Mono weight/size scales)
- Motion Tokens (Durations & cubic-bezier easing curves)
- Spacing, Elevation, and Radius Tokens
- Base Atomic Components (`DiButton`, `DiCard`, `DiChip`, `DiRingProgress`, `DiInput`, `DiGlassContainer`)

---

## Sprint 0.4 — Today Dashboard Master UX & State Machine Spec
Completing the 10-step design pipeline specifically for Screen 01 ("Today" Dashboard):
- UX Specification & Section Hierarchy
- Interaction & Gesture Specification
- Component Tree Breakdown
- State Machine (FSM) Matrix
- Responsive Breakpoint Layouts (Mobile, Tablet, Desktop)
- Accessibility & Screen Reader Flow
- Performance Budgets & Acceptance Verification Metrics

---

# Sign-Off & Agreement

By committing this document to `docs/62_PRODUCTION_RULES_AND_STANDARDS.md`, all future sprint deliverables in DiLang are bound by these 7 Production Rules and the Phase 0 Foundation roadmap.
