# 23. Curriculum Graph Architecture Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Curriculum Graph

---

## 1. Directed Acyclic Graph (DAG) Structure

Learning paths in DiLang are represented as a directed acyclic graph $C = (V, E)$ where nodes $V$ are learning objectives and edges $E$ are strict prerequisite dependencies.

```
 [A1: Basic Nouns] ----> [A1: Present Tense Verbs] ----> [A1: V2 Word Order]
                                                               │
                                                               v
                                                   [A1 Objective: Order Food]
```

---

## 2. Node & Prerequisite Rules

- **Unlocking Condition**: Objective $O_k$ unlocks if $\forall p \in Prerequisites(O_k)$, $MasteryScore(p) \ge 0.80$.
- **No Cyclic Dependencies**: Graph verification algorithm validates that $C$ is strictly acyclic upon curriculum loading.
