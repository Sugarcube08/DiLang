# DiLang Memory System Specification

## 1. Executive Summary

The DiLang Memory System (`dilang_memory`) manages epistemic memory representation, user skill trees, and decay-weighted vector storage for semantic retrieval. It establishes the bridge between abstract user knowledge state and concrete FSRS card scheduling.

---

## 2. Epistemic Dual-Memory Architecture

```
                      ┌───────────────────────────┐
                      │   DiLang Memory System    │
                      └─────────────┬─────────────┘
                                    │
            ┌───────────────────────┴───────────────────────┐
            ▼                                               ▼
┌───────────────────────────┐                   ┌───────────────────────────┐
│    Declarative Memory     │                   │     Procedural Memory     │
│ (Vocab, Rules, Facts)     │                   │  (Collocation speed, WPM, │
│ Indexed via FSRS Cards    │                   │   Spoken Fluency Hooks)   │
└───────────┬───────────────┘                   └───────────┬───────────────┘
            │                                               │
            └───────────────────────┬───────────────────────┘
                                    ▼
                      ┌───────────────────────────┐
                      │ Dynamic Skill Tree Graph  │
                      └───────────────────────────┘
```

---

## 3. User Skill Tree Graph Schema

The user's overall mastery is represented as an acyclic graph of skill nodes.

### 3.1 Node Status Lifecycle
1. **LOCKED**: Dependencies not yet satisfied ($<80\%$ prerequisite score).
2. **UNLOCKED**: Eligible for discovery and initial review.
3. **PRACTICING**: Currently in active learning/review cycles.
4. **MASTERED**: Retrievability $R \ge 0.90$ across all associated sub-cards with $S \ge 30.0$ days.

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SkillNode {
    pub id: String,
    pub name: String,
    pub category: SkillCategory, // GrammarConcept, VocabCluster, DialogueScenario
    pub prerequisites: Vec<String>,
    pub item_ids: Vec<i64>, // Pointer to FSRS Card IDs
    pub current_mastery: f32, // [0.0 - 1.0]
    pub status: NodeStatus,
}
```

---

## 4. Decay-Weighted Vector Database (HNSW Vector Index)

To enable contextually aware conversation prompts, DiLang stores sentence embeddings in a local vector table indexed using Hierarchical Navigable Small World (HNSW) graphs in Rust.

### 4.1 Decay Score Formulation
When querying semantic memory for dynamic prompt injection, embedding vector similarities are scaled by the exponential memory decay of the item:

$$\text{Score}(\mathbf{q}, \mathbf{v}_i) = \cos(\mathbf{q}, \mathbf{v}_i) \cdot \exp\left(-\lambda \cdot \frac{t_i}{S_i}\right)$$

Where:
- $\mathbf{q}$: Current conversation context vector.
- $\mathbf{v}_i$: Embedded historical sentence vector.
- $\cos(\cdot, \cdot)$: Cosine similarity measure.
- $t_i$: Elapsed days since last recall.
- $S_i$: Memory stability of item $i$.
- $\lambda = 0.5$: Decay weight scaling factor.

---

## 5. Storage Contract

The Memory System uses SQLite tables `skill_tree_nodes`, `skill_tree_edges`, and binary blob columns for 384-dimensional vector embeddings generated locally by dynamic Quantized MiniLM/Gemma embedding models.
