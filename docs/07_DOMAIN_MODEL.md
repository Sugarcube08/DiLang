# 07. Domain Model & Learner Graph Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Source of Truth — Domain Contracts

---

## 1. Ubiquitous Language & Glossary

- **Learner Graph**: A directed multi-graph representing the complete state of a user's language capabilities across vocabulary, grammar, pronunciation, listening, writing, reading, and conversation.
- **Lexical Unit**: The smallest unit of vocabulary tracking (can be a word, idiom, compound noun, or phrasal verb).
- **Grammar Rule**: A discrete structural pattern of target language syntax (e.g., German V2 word order, French subjunctive mood trigger).
- **Phoneme Unit**: An acoustic sound target in the target language's International Phonetic Alphabet (IPA) set.
- **Stability ($S$)**: The time required for retrievability to fall from 100% to 90% under FSRS-4.5.
- **Difficulty ($D$)**: The intrinsic complexity of a lexical or grammatical item on a 1.0 - 10.0 scale.
- **Retrievability ($R$)**: The probability of successfully recalling an item at time $t$.

---

## 2. Learner Graph Structure & Subgraphs

The overall Learner Graph $G = (V, E)$ consists of seven interconnected subgraphs:

```
        +-------------------------------------------------------+
        |                 LEARNER GRAPH (G)                     |
        +-------------------------------------------------------+
            |          |           |            |           |
            v          v           v            v           v
       +--------+  +---------+  +----------+  +----------+  +-------------+
       | Lexical|  | Grammar |  | Phoneme  |  | Listening|  | Conversation|
       | Nodes  |  | Nodes   |  | Nodes    |  | Nodes    |  | Nodes       |
       +--------+  +---------+  +----------+  +----------+  +-------------+
```

### 2.1 Lexical Unit Entity Specification

```dart
class LexicalUnit {
  final LexicalUnitId id;
  final String targetLanguage;
  final String text;
  final String lemma;
  final String partOfSpeech; // e.g., NOUN, VERB, ADJ
  final String ipaPhonetic;
  final List<String> translations;
  final FsrsMemoryState memoryState;
  final DateTime createdAt;

  const LexicalUnit({
    required this.id,
    required this.targetLanguage,
    required this.text,
    required this.lemma,
    required this.partOfSpeech,
    required this.ipaPhonetic,
    required this.translations,
    required this.memoryState,
    required this.createdAt,
  });
}
```

### 2.2 FSRS Memory State Value Object

```dart
class FsrsMemoryState {
  final double stability;      // Memory stability (days)
  final double difficulty;     // Item difficulty (1.0 to 10.0)
  final int reps;              // Total review count
  final int lapses;            // Total recall failures
  final FsrsState state;       // New, Learning, Review, Relearning
  final DateTime lastReviewed; // Timestamp of last exercise attempt
  final DateTime due;          // Scheduled next review timestamp

  const FsrsMemoryState({
    required this.stability,
    required this.difficulty,
    required this.reps,
    required this.lapses,
    required this.state,
    required this.lastReviewed,
    required this.due,
  });
}
```

### 2.3 Grammar Rule Entity Specification

```dart
class GrammarRule {
  final GrammarRuleId id;
  final String code;             // e.g., "GER_V2_ORDER"
  final String title;
  final String description;
  final String CEFRLevel;        // A1, A2, B1, B2, C1, C2
  final List<GrammarRuleId> prerequisites;
  final FsrsMemoryState memoryState;

  const GrammarRule({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.CEFRLevel,
    required this.prerequisites,
    required this.memoryState,
  });
}
```

---

## 3. Aggregate Root Invariants

1. **Memory State Invariant**: $Stability > 0.0$ and $1.0 \le Difficulty \le 10.0$.
2. **Review Due Invariant**: For any item in state `Review`, `due` date must equal `lastReviewed + stability_days`.
3. **Graph Dependency Invariant**: No grammar rule can be marked as `Mastered` unless 80% of its declared `prerequisites` are at least in state `Learning`.
