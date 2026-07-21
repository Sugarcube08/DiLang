# DiLang Testing Strategy & Quality Gates

Every deliverable in DiLang is evaluated against **Five Independent Quality Gates**:

---

## 1. The Five Quality Gates

| Quality Gate | Verification Requirement |
| :--- | :--- |
| **1. Engineering Gate** | Zero crashes, locked 60 FPS UI, SQLite persistence, `< 200ms` startup, 100% test pass. |
| **2. Pedagogy Gate** | Aligned with CEFR A1–C2 competency objectives, FSRS 4.5 retrievability, and pre/post session briefings. |
| **3. AI Quality Gate** | Declarative scenario execution produces level-constrained, patient, persona-bound dialogue. |
| **4. Intelligence Gate** | 100% explainable mission recommendations citing knowledge graph node dependencies. |
| **5. Evaluation Gate** | `AutomatedEvaluationFramework` runs educational regression test suites verifying ground-truth mission assignment. |

---

## 2. Test Suite Locations

- `packages/storage/test`: SQLite DDL, migrations, integrity check, secure storage, and repository tests.
- `packages/core/test`: System bootstrapper, feature flags registry, event bus, and capability registry.
- `packages/learning_engine/test`: FSRS 4.5 memory engine, mission generator, session lifecycle, and evaluation framework.
- `packages/conversation/test`: Dialogue manager, scenario parser, and learning replay.
- `packages/application/test`: Production readiness gate, FTUE onboarding, Today Dashboard experience, and 5-gate tests.
