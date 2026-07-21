# Feature Contract 06 — Learner Intelligence Engine & Explainability System

**Feature Name:** Learner Cognitive Model, Probabilistic Knowledge Graph, Error Intelligence & Retention Prediction Engine  
**Sprint:** Sprint 6 — Phase 2 (Adaptive Learning Intelligence Platform)  
**Status:** Approved Feature Contract  
**Target Packages:** `packages/learning_engine`, `packages/language`, `packages/memory`, `packages/storage`, `packages/application`, `packages/product_ui`, `apps/desktop`

---

## 1. Business Purpose & Intelligence Platform Vision

Transform DiLang into an **adaptive learning intelligence platform**. The Learner Intelligence Engine continuously models *what the learner truly knows*, inferring multi-dimensional cognitive capabilities, mapping underlying causes of recurring errors, predicting memory decay, and providing 100% explainable mission recommendations.

---

## 2. Core Intelligence Architecture

```
[ Session Replays & Domain Event Log ]
                  │
                  ▼
   [ Error Intelligence Analyzer ]
                  │
                  ▼
   [ Learner Cognitive Model ]
   ├── Multi-Dimensional Mastery Metrics
   ├── Error Category & Root Cause Taxonomy
   └── Knowledge Decay & Retention Forecasts
                  │
                  ▼
   [ Explainability & Prediction Engine ]
                  │
                  ▼
   [ TodayDashboardUseCase & Client APIs ]
```

---

## 3. Core Domain Entities (`packages/learning_engine`)

```dart
class LearnerCognitiveModel extends Equatable {
  final String userId;
  final double vocabularyMastery; // 0.0 - 1.0
  final double grammarMastery;
  final double pronunciationConfidence;
  final double listeningComprehension;
  final double readingFluency;
  final double writingFluency;
  final double recallStability;
  final double cognitiveLoadIndex;
  final double learningVelocity;
  final double estimatedCefrReadiness; // e.g. 0.82 (82% to B1)

  const LearnerCognitiveModel({
    required this.userId,
    required this.vocabularyMastery,
    required this.grammarMastery,
    required this.pronunciationConfidence,
    required this.listeningComprehension,
    required this.readingFluency,
    required this.writingFluency,
    required this.recallStability,
    required this.cognitiveLoadIndex,
    required this.learningVelocity,
    required this.estimatedCefrReadiness,
  });
}

class ErrorCauseAnalysis extends Equatable {
  final String errorId;
  final String mistakeText;
  final String errorCategory; // "Grammar", "Phonetic", "Vocabulary"
  final String underlyingCause; // "Accusative masculine article inflection"
  final int totalOccurrences;
  final int totalRecoveries;
  final String recommendedIntervention;

  const ErrorCauseAnalysis({
    required this.errorId,
    required this.mistakeText,
    required this.errorCategory,
    required this.underlyingCause,
    required this.totalOccurrences,
    required this.totalRecoveries,
    required this.recommendedIntervention,
  });
}

class ExplainableMissionRecommendation extends Equatable {
  final String missionTitle;
  final String suggestedAction;
  final List<String> explicitReasons; // ["82% vocabulary retained", "accusative still unstable", "CEFR 1.4 objective incomplete"]
  final List<String> predictedHighDecayItems; // ["Bahnhof", "Bestellung", "einen"]

  const ExplainableMissionRecommendation({
    required this.missionTitle,
    required this.suggestedAction,
    required this.explicitReasons,
    required this.predictedHighDecayItems,
  });
}
```

---

## 4. SQLite Schema Extension (`packages/storage`)

New Table DDL:
- `cognitive_models` (user_id TEXT PRIMARY KEY, vocab_mastery REAL, grammar_mastery REAL, recall_stability REAL, cefr_readiness REAL, updated_at INTEGER)
- `error_intelligence` (error_id TEXT PRIMARY KEY, user_id TEXT, mistake_text TEXT, error_category TEXT, underlying_cause TEXT, occurrences INTEGER, recoveries INTEGER, intervention TEXT)

---

## 5. The Four Quality Gates

| Gate | Verification Requirement |
| :--- | :--- |
| **1. Engineering** | Zero crashes, clean SQLite queries for cognitive state and error analytics, 100% test pass. |
| **2. Pedagogy** | Aligned with CEFR progression stages, FSRS retention forecasting, and targeted root-cause remediation. |
| **3. AI Quality** | Coherent error classification, patient correction guidance, level-appropriate recommendations. |
| **4. Intelligence** | Recommendations are 100% explainable with explicit reasons, retention forecasts, and error root-cause interventions. |
