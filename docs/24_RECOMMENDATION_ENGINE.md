# 24. Deterministic Recommendation Engine Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Recommendation Engine

---

## 1. Recommendation Pipeline

The `RecommendationEngine` evaluates queues without randomness:

1. **Priority 1: Urgent Memory Reviews** ($R < 0.85$ under FSRS-4.5).
2. **Priority 2: Unlocked Curriculum Prerequisite Items** ($Mastery \ge 0.80$ on prerequisite nodes).
3. **Priority 3: New Vocabulary / Grammar Concepts** (if review queue load is under `maxReviewQueueLoad`).
4. **Priority 4: Multimodal Conversation / Fluency Practice**.

---

## 2. Recommendation Data Model

```json
{
  "queueType": "DUE_REVIEW",
  "itemKey": "voc_haus",
  "priorityScore": 9.45,
  "diagnostic": {
    "predictedRetrievability": 0.81,
    "daysOverdue": 1.2
  }
}
```
