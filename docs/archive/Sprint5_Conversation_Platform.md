# Feature Contract 05 — Conversation Platform, Scenario Engine & Learning Replay

**Feature Name:** Conversation Platform, Dialogue Manager, Scenario Registry, Predictive Coaching 2.0 & Learning Replay System  
**Sprint:** Sprint 5 — Phase 2 (Learning Experience)  
**Status:** Approved Feature Contract  
**Target Packages:** `packages/conversation`, `packages/language`, `packages/learning_engine`, `packages/storage`, `packages/application`, `packages/product_ui`, `apps/desktop`

---

## 1. Business Purpose

Deliver a rich, patient AI conversation experience. The Dialogue Manager controls context, persona, and grammar targets; the Scenario Registry provides structured CEFR scenarios; Predictive Coaching 2.0 bookends sessions with pre-session briefings and post-session evidence logs; and the Learning Replay System records immutable transcripts for progress auditing.

---

## 2. Core Entities (`packages/conversation` & `packages/learning_engine`)

```dart
class ConversationScenario extends Equatable {
  final String id;
  final String title;
  final String description;
  final String cefrLevel;
  final int estimatedDurationMinutes;
  final String personaName;
  final String personaRole;
  final List<String> targetVocabulary;
  final List<String> targetGrammarRules;
  final String culturalNote;

  const ConversationScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.cefrLevel,
    required this.estimatedDurationMinutes,
    required this.personaName,
    required this.personaRole,
    required this.targetVocabulary,
    required this.targetGrammarRules,
    required this.culturalNote,
  });
}

class LearningReplayTurn extends Equatable {
  final int turnIndex;
  final String tutorPrompt;
  final String learnerResponse;
  final String correctedResponse;
  final String grammarNote;
  final double phoneticScore;

  const LearningReplayTurn({
    required this.turnIndex,
    required this.tutorPrompt,
    required this.learnerResponse,
    required this.correctedResponse,
    required this.grammarNote,
    required this.phoneticScore,
  });
}

class LearningReplayTranscript extends Equatable {
  final String transcriptId;
  final String sessionId;
  final String scenarioId;
  final DateTime timestamp;
  final List<LearningReplayTurn> turns;
  final int speakingConfidenceBefore;
  final int speakingConfidenceAfter;
  final String evidenceSummary;

  const LearningReplayTranscript({
    required this.transcriptId,
    required this.sessionId,
    required this.scenarioId,
    required this.timestamp,
    required this.turns,
    required this.speakingConfidenceBefore,
    required this.speakingConfidenceAfter,
    required this.evidenceSummary,
  });
}
```

---

## 3. Dialogue Pipeline & Pre/Post Predictive Coaching

```
[ Scenario Selection ]
         │
         ▼
[ Pre-Session Briefing (Coach 2.0) ] ──▶ "Watch for accusative 'den' & adjective endings."
         │
         ▼
[ Dialogue Manager Turn Loop ]
   ├── Speaker: Tutor ("Grüß Gott! Was darf ich Ihnen bringen?")
   ├── Speaker: Learner ("Ich möchte einen heiße Kaffee.")
   └── Evaluator: Identifies error & generates correction note
         │
         ▼
[ Post-Session Briefing (Evidence) ] ──▶ "Speaking Confidence 72 ➔ 79 (+7 pts). 14 turns."
         │
         ▼
[ Learning Replay Transcribed to SQLite `replay_transcripts` ]
```

---

## 4. SQLite Schema Extension (`packages/storage`)

New Table DDL:
- `scenarios` (id TEXT PRIMARY KEY, title TEXT, cefr_level TEXT, persona_name TEXT, target_vocab TEXT, target_grammar TEXT)
- `replay_transcripts` (transcript_id TEXT PRIMARY KEY, session_id TEXT, scenario_id TEXT, timestamp INTEGER, confidence_before INTEGER, confidence_after INTEGER, evidence_summary TEXT, turns_json TEXT)

---

## 5. Three Quality Gates Verification

- **Engineering Gate**: SQLite `replay_transcripts` append, zero UI jank, 100% test pass.
- **Pedagogy Gate**: Pre/post session coaching briefing, CEFR A1-C2 scenario metadata, explainable evidence calculations.
- **AI Gate**: Level-constrained vocabulary, patient dialogue corrections, zero hallucination.
