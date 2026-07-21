# ADR 002: Core API Stability, Release Management & Validation Lifecycle

**Date:** 2026-07-22  
**Status:** Approved Architectural & Release Decision Record  
**Target:** DiLang v1.0.0-alpha Baseline to v2.0 Release Candidate  

---

## 1. Frozen API-Stable Packages

The following 8 core packages are declared **API-Stable**. Any structural changes or breaking modifications to their public interfaces require a formal Architecture Decision Record (ADR):

1. `package:dilang_core`
2. `package:dilang_storage`
3. `package:dilang_learning_engine`
4. `package:dilang_memory`
5. `package:dilang_conversation`
6. `package:dilang_language` (Knowledge Graph)
7. `package:dilang_learner`
8. `package:dilang_application` (Dashboard View Models & Bootstrap Pipeline)

---

## 2. Release Progression Lifecycle

Sprints are replaced with formal **Validation & Release Cycles**:

```
v1.0.0-alpha (Baseline Frozen)
       │
       ▼
Validation Cycle 1: Device Validation & CI/CD Packaging Pipeline
       │
       ▼
v1.1.0-alpha (Automated Build & Telemetry Baseline)
       │
       ▼
Validation Cycle 2: Content Expansion & Security Review
       │
       ▼
v1.2.0-beta (Alpha Cohort 10-20 Learners)
       │
       ▼
Public Beta ➔ v1.5 ➔ Release Candidate ➔ v2.0 Production
```

---

## 3. Automated CI/CD & Build Matrix (.github/workflows/ci_release.yml)

The release process is fully automated via GitHub Actions:
- **Triggers**: Push to `release/v2.x` or tags `v*`
- **Matrix**: Linux x86_64 Desktop Bundle & Android APK/AAB
- **Validation Sequence**:
  1. Static Code Analysis (`flutter analyze`)
  2. Formatting Check (`dart format --output=none --set-exit-if-changed .`)
  3. Multi-Package Unit & Integration Tests (`dart test`)
  4. Automated Educational Evaluation Suite (`AutomatedEvaluationFramework`)
  5. Artifact Bundling (`flutter build linux --release` & `flutter build apk --release`)

---

## 4. Empirical Learner Validation Matrix (Alpha Cohort 10–20 Users)

The success of the platform is validated empirically across 5 core telemetry metrics:
1. **Startup Telemetry**: Bootstrap pipeline execution time `< 20ms`.
2. **Mission Completion Ratio**: % of recommended daily missions completed without abandonment.
3. **FSRS Retention Gain**: Observed retrievability improvement over 14-day & 30-day review cycles.
4. **Coaching Utility**: Learner error reduction following pre-session briefing interventions.
5. **CEFR Readiness Correlation**: Correlation between DiLang estimated CEFR score and independent linguistic assessment.
