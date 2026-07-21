# 21. Learning Engine Architecture Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Core Intellectual Property

---

## 1. Overview & Policy Engine Philosophy

The **Learning Engine** is the core intellectual property of DiLang. It operates as a deterministic decision machine that evaluates language data, learner state, memory stability (FSRS-4.5), and domain event streams against versioned **Learning Policies**.

```
 Learner Graph + FSRS Memory + Language Knowledge + Domain Events
                                 │
                                 v
                     +-----------------------+
                     |  POLICY ENGINE        |
                     |  (Versioned Rules)    |
                     +-----------+-----------+
                                 │
                                 v
                     +-----------------------+
                     | LEARNING ORCHESTRATOR |
                     +-----------+-----------+
                                 │
                                 v
               Adaptive Recommendations + Diagnostics
```

---

## 2. Policy Engine Subsystem

All decision thresholds are codified in versioned `LearningPolicy` objects rather than hard-coded heuristics:

- `maxNewItemsPerDay`: Default = 15 items.
- `maxReviewQueueLoad`: Default = 100 items.
- `targetRetentionThreshold`: Default = 0.90 ($R \ge 0.90$).
- `adaptiveDifficultyStrategy`: Conservative, Balanced, Accelerated.
- `cefrPromotionThreshold`: 85% mastery across required curriculum nodes.

---

## 3. Explainable Recommendation Diagnostics

Every recommendation produced by the engine carries an explicit diagnostic trace explaining *why* the item was selected:

```json
{
  "recommendedItem": "voc_haus",
  "recommendedAction": "FSRS_REVIEW",
  "diagnostic": {
    "retrievability": 0.78,
    "targetRetention": 0.90,
    "lastReviewedDaysAgo": 9.2,
    "reason": "Retrievability dropped below 0.90 threshold; required prerequisite for objective 'ORDER_FOOD'."
  }
}
```
