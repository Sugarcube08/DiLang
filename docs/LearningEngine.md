# DiLang — Learning Engine & Memory Specification

**Version**: 2.0-RESET  
**Status**: Authoritative  

---

## 1. FSRS-4.5 Math Engine

Human memory retention is calculated using the deterministic **Free Spaced Repetition Scheduler (FSRS-4.5)** algorithm in `lib/modules/learning/services/fsrs_engine.dart`.

### Retrievability Formula
$$R(t, S) = \left(1 + \frac{19}{81} \cdot \frac{t}{S}\right)^{-1}$$

Where:
- $t$: Elapsed time in days since last review.
- $S$: Stability of the memory item in days.
- $R$: Predicted retrievability ($0.0 - 1.0$).

---

## 2. Learner Cognitive Model & Error Cause Analysis

- **`LearnerIntelligenceEngine`**: Infers real-time cognitive state (`vocabularyMastery`, `grammarMastery`, `recallStability`, `estimatedCefrReadiness`).
- **`ErrorCauseAnalysis`**: Categorizes mistake patterns (Grammar vs Vocabulary decay) and generates targeted interventions.
- **`MissionGenerator`**: Dynamically crafts daily scenarios tailored to current user review queues and available time slots.
