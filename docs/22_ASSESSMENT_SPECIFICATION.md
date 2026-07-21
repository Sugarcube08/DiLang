# 22. Multimodal Assessment Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Assessment Engine

---

## 1. Multimodal Evidence Aggregation

Rather than relying on single pass/fail test scores, DiLang accumulates weighted evidence across seven modality streams:

```
  Modalities          Weight   Evidence Metric
  -------------------------------------------------------------
  Vocabulary Recall   0.20     FSRS retrievability & response time
  Grammar Accuracy    0.20     Syntactic error rate in composition
  Pronunciation IPA   0.15     Whisper acoustic confidence score
  Listening Comp.     0.15     Auditory cloze accuracy
  Writing Quality     0.10     Morphological & spelling accuracy
  Reading Speed       0.10     Tokens/min comprehension speed
  Conversation Flow   0.10     Turn latency & discourse pragmatic score
```

---

## 2. Evidence Scoring Formula

$$MasteryScore = \sum_{m=1}^{7} w_m \cdot Evidence_m$$

Where $\sum w_m = 1.0$, and $Evidence_m \in [0.0, 1.0]$.
