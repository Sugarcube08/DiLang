# Feature Contract 07 — Knowledge Platform, Curriculum Engine & Automated Evaluation Framework

**Feature Name:** Interconnected Knowledge Graph, Graph-Traversal Curriculum Engine, Declarative Scenario Authoring & Automated Evaluation Framework  
**Sprint:** Sprint 7 — Phase 3 (Knowledge Platform)  
**Status:** Approved Feature Contract  
**Target Packages:** `packages/language`, `packages/learning_engine`, `packages/conversation`, `packages/storage`, `packages/application`, `apps/desktop`

---

## 1. Business Purpose & Knowledge Platform Vision

Establish the canonical representation of language in DiLang. Every concept (vocabulary, grammar rule, phrase, scenario, CEFR objective) exists as a weighted `KnowledgeNode` within a multi-dimensional directed acyclic knowledge graph. The Curriculum Engine navigates optimal traversal paths, declarative YAML/JSON scenarios drive the Dialogue Manager, and the Automated Evaluation Framework enforces educational decision reproducibility.

---

## 2. Universal Knowledge Graph Architecture

```
[ KnowledgeNode: "der" (article) ]
               │
               ▼
[ KnowledgeNode: "accusative_masculine" (grammar) ]
               │
               ▼
[ KnowledgeNode: "scn_cafe_vienna" (scenario) ]
               │
               ▼
[ KnowledgeNode: "cefr_a1_obj_3.2" (objective) ]
               │
               ▼
[ Evidence Collection & Validation Engine ]
```

---

## 3. Core Domain Entities (`packages/language` & `packages/learning_engine`)

```dart
enum KnowledgeNodeType {
  vocabulary,
  grammar,
  phrase,
  idiom,
  pronunciationRule,
  listeningPattern,
  readingPattern,
  writingPattern,
  conversationSkill,
  culturalNote,
  cefrObjective,
  assessmentObjective,
}

class KnowledgeNode extends Equatable {
  final String id;
  final String label;
  final KnowledgeNodeType type;
  final String cefrLevel;
  final Map<String, double> outgoingEdgeWeights; // targetNodeId -> weight
  final Map<String, dynamic> metadata;

  const KnowledgeNode({
    required this.id,
    required this.label,
    required this.type,
    required this.cefrLevel,
    this.outgoingEdgeWeights = const {},
    this.metadata = const {},
  });
}

class DeclarativeScenarioManifest extends Equatable {
  final String scenarioId;
  final String title;
  final String cefrLevel;
  final List<String> requiredNodeIds;
  final List<String> targetGrammarRuleIds;
  final String preSessionCoachingText;
  final String postSessionCoachingText;

  const DeclarativeScenarioManifest({
    required this.scenarioId,
    required this.title,
    required this.cefrLevel,
    required this.requiredNodeIds,
    required this.targetGrammarRuleIds,
    required this.preSessionCoachingText,
    required this.postSessionCoachingText,
  });
}

class EvaluationTestResult extends Equatable {
  final String testId;
  final String testName;
  final bool passed;
  final String expectedOutput;
  final String actualOutput;
  final double confidenceScore;

  const EvaluationTestResult({
    required this.testId,
    required this.testName,
    required this.passed,
    required this.expectedOutput,
    required this.actualOutput,
    required this.confidenceScore,
  });
}
```

---

## 4. SQLite Schema Extension (`packages/storage`)

New Table DDL:
- `knowledge_nodes` (id TEXT PRIMARY KEY, label TEXT, type TEXT, cefr_level TEXT, metadata_json TEXT, edge_weights_json TEXT)
- `scenario_manifests` (scenario_id TEXT PRIMARY KEY, title TEXT, cefr_level TEXT, required_nodes_json TEXT, target_grammar_json TEXT, pre_coaching TEXT, post_coaching TEXT)

---

## 5. The Five Quality Gates Verification

| Gate | Verification Requirement |
| :--- | :--- |
| **1. Engineering** | Zero crashes, clean graph traversal algorithms, 100% SQLite serialization fidelity. |
| **2. Pedagogy** | Graph edges align with CEFR prerequisites and FSRS decay curves. |
| **3. AI Quality** | Declarative scenario execution produces coherent, persona-bound dialogue. |
| **4. Intelligence** | Explainable recommendations directly cite knowledge graph node dependencies. |
| **5. Evaluation** | Automated Evaluation Framework runs regression test suites verifying Mission Generator and Coaching decisions match expected ground-truth targets. |
