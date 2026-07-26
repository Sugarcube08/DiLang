# DiLang Learning Engine Specification

## 1. Executive Summary

The DiLang Learning Engine (`dilang_learning`) manages the pedagogical pipeline, curriculum graph traversal, adaptive difficulty scaling, and skill acquisition models. It translates cognitive science principles—specifically the Zone of Proximal Development (ZPD) and Spaced Spoken Production—into dynamic execution graphs executed entirely within the Rust core.

---

## 2. Pedagogy Pipeline Architecture

```
[ Raw User Interaction ]
          │
          ▼
┌─────────────────────────┐
│ Speech/Text Ingestion   │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Error Diagnostic Parser │ ◄── (Grammar & Vocab Engines)
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ ZPD Evaluator           │ ◄── (Memory System & FSRS Engine)
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Dynamic Scaffolder      │ ──► Generates Next Task / Prompt Variant
└─────────────────────────┘
```

### 2.1 Zone of Proximal Development (ZPD) Engine
The engine continuously maintains a real-time estimate of the user's current mastery frontier $\theta \in [0, 1]$.
- **Target Difficulty Window**: Tasks are selected such that the expected success probability $P(\text{success}) \in [0.70, 0.85]$.
- **Dynamic Scaffolding**: If $P(\text{success}) < 0.70$, scaffolding prompts (cloze hints, visual cues, phonetic transcriptions) are injected. If $P(\text{success}) > 0.85$, scaffolding is removed and complex grammatical structures are introduced.

---

## 3. Curriculum Graph Schema

The curriculum is represented as a Directed Acyclic Graph (DAG) stored in SQLite and indexed in memory via Rust structures.

### 3.1 Node Definition (`CurriculumNode`)
```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CurriculumNode {
    pub id: String,
    pub cefr_level: CefrLevel, // A1, A2, B1, B2, C1, C2
    pub domain: DomainCategory, // Grammar, Vocabulary, Pragmatics, Phonetics
    pub title: String,
    pub prerequisites: Vec<String>, // Edge dependencies
    pub target_competencies: Vec<String>,
    pub base_difficulty: f32, // [0.0 - 10.0]
}
```

### 3.2 Edge Progression Logic
- A node $N_i$ becomes `UNLOCKED` when $\forall p \in \text{prerequisites}(N_i)$, $\text{MasteryScore}(p) \ge 0.80$.
- Edge weights represent semantic distance and prerequisite strength.

---

## 4. Adaptive Difficulty Scaling Algorithm

The engine dynamically adjusts target task parameters using the following formula:

$$D_{\text{adj}} = D_{\text{base}} + \alpha \cdot (1.0 - \text{SuccessRate}_{10}) - \beta \cdot \log_{10}(\text{ResponseTimeMs}) + \gamma \cdot \text{FSRS}_{\text{decay}}$$

Where:
- $\alpha = 1.5$: Penalty multiplier for recent error rate across the last 10 trials.
- $\beta = 0.5$: Speed bonus coefficient.
- $\gamma = 0.8$: Weight of memory decay from the FSRS engine.

---

## 5. Integration Contracts

- **Input**: User review logs from `dilang_fsrs`, syntactic analysis from `dilang_grammar`, token hits from `dilang_vocab`.
- **Output**: Next recommended lesson node, target scenario configurations, dynamic scaffolding levels.
