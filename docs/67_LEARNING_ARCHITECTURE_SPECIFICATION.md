# 67. DiLang Master Learning Architecture Specification

**Document Version:** 1.0.0  
**Status:** Single Source of Educational Truth  
**Target:** Phase 2 — Learning Experience & Pedagogical Quality Gate  

---

## 1. Executive Pedagogical Vision

> **"DiLang enables a learner to achieve functional CEFR fluency (A1 to C2) through evidence-based AI conversation, spaced memory scheduling, predictive coaching, and active scenario immersion."**

This specification defines how DiLang teaches, measures acquisition, authors dialogue scenarios, structures evidence, and enforces educational quality.

---

## 2. Core Instructional Methodology

1. **Input Hypothesis + 1 (i + 1)**: Language input is calibrated to be 90% comfortable and 10% challenging based on the learner's active Knowledge Graph state.
2. **Predictive Session Bookending**: Every learning session begins with a pre-session briefing ("Watch for accusative masculine articles 'den'") and concludes with evidence-based feedback ("Accusative accuracy increased from 42% to 71%").
3. **Implicit & Explicit Grammar Acquisition**: Grammar targets are embedded organically into dialogue scenarios before being reinforced in targeted matrix drills.
4. **Evidence-Based Mastery**: Fluency ratings are never arbitrary percentages. Every claim is backed by explicit evidence logs (e.g. turn counts, response latency, hesitation metrics, grammar accuracy).

---

## 3. CEFR Progression & Competency Matrix

| CEFR Level | Active Vocabulary | Target Scenarios | Grammar Mastery Targets |
| :---: | :---: | :--- | :--- |
| **A1** | 500 words | Greetings, Café, Shopping, Directions | Present Tense, Gender Articles (Der/Die/Das), Nominative/Accusative |
| **A2** | 1,200 words | Restaurant, Hotel, Train Station, Weather | Past Tense (Perfekt), Modal Verbs, Dative Case, Prepositions |
| **B1** | 2,500 words | Work Office, Doctor, Travel Delays, Apartment Rent | Subordinate Clauses (Weil, Dass, Wenn), Genitive Case, Passive Voice |
| **B2** | 4,000 words | Job Interview, Negotiations, Debates, Cultural News | Subjunctive (Konjunktiv II), Complex Prepositions, Idiomatic Phrasals |
| **C1/C2** | 8,000+ words | Academic Lectures, Professional Presentations | Nuanced Pragmatics, Stylistic Register Shift, Domain Mastery |

---

## 4. Conversation Scenario Authoring & Metadata Schema

Every dialogue scenario is authored with explicit pedagogical attributes:

```json
{
  "scenarioId": "scn_cafe_de_a1",
  "title": "Ordering at a Viennese Café",
  "cefrLevel": "A1",
  "estimatedDurationMinutes": 15,
  "persona": {
    "name": "Greta",
    "role": "Café Waitress in Vienna",
    "personality": "Patient, polite, slightly formal",
    "accent": "Austrian German (Hochdeutsch standard)"
  },
  "objectives": {
    "vocabulary": ["der Kaffee", "die Speisekarte", "das Wasser", "zahlen", "bitte"],
    "grammar": ["accusative_masculine_article", "polite_verb_inversion"],
    "speakingConfidenceTarget": 75
  },
  "culturalNotes": "In Vienna, it is customary to specify 'Einen Verlängerten' rather than 'Americano'."
}
```

---

## 5. Predictive Coaching Engine 2.0

```
┌──────────────────────────────────────────────────────────┐
│                   PRE-SESSION BRIEFING                   │
│ "Watch for adjective endings after accusative articles.  │
│ You'll encounter 'Einen heißen Kaffee' in this dialogue."│
└──────────────────────────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────┐
│                 LIVE DIALOGUE EXECUTION                  │
│ Learner speaks → Dialogue Manager monitors grammar/VAD  │
└──────────────────────────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────┐
│                   POST-SESSION REVIEW                    │
│ "Great improvement! Accusative accuracy 42% ➔ 71%.        │
│ 14 successful turns, 0 hesitation prompts."             │
└──────────────────────────────────────────────────────────┘
```

---

## 6. Evidence-Based Progression System

Fluency metrics are calculated deterministically from raw telemetry:

```
Speaking Confidence = (0.4 × AccuracyRatio) + (0.3 × LatencyScore) + (0.3 × TurnCompletionRatio)
```

**Sample Evidence Log**:
- **Baseline Confidence**: `72 / 100`
- **Session Confidence**: `79 / 100`
- **Evidence**:
  - `14` successful conversation turns executed.
  - Average turn response latency: `1.8 seconds` (down from `3.2s`).
  - Zero hesitation prompts requested.
  - Accusative masculine article accuracy: `85%`.

---

## 7. Learning Replay System (Immutable Learning Transcripts)

Every session creates an immutable `LearningReplayTranscript` persisted in SQLite:

```json
{
  "transcriptId": "tr_99812",
  "sessionId": "sess_cafe_001",
  "timestamp": 1774149600000,
  "turns": [
    {
      "turnIndex": 1,
      "tutorPrompt": "Grüß Gott! Was darf ich Ihnen bringen?",
      "learnerAudioDurationMs": 2400,
      "learnerTranscript": "Ich möchte einen heiße Kaffee, bitte.",
      "correctedTranscript": "Ich möchte einen heißen Kaffee, bitte.",
      "grammarNotes": "Masculine accusative requires weak adjective ending '-en' (einen heißen Kaffee).",
      "phoneticScore": 0.92
    }
  ]
}
```

---

## 8. The Three Quality Gates

| Dimension | Mandatory Acceptance Criteria |
| :--- | :--- |
| **1. Engineering** | Zero crashes, 60 FPS UI, SQLite persistence, `< 50ms` response evaluation latency, 100% test pass rate. |
| **2. Pedagogy** | 100% aligned with CEFR competencies, FSRS memory decay curves, pre/post predictive coaching, and explainable evidence. |
| **3. AI Quality** | Zero hallucinated grammar rules, strict persona adherence, level-appropriate vocabulary constraints, and patient correction prompts. |
