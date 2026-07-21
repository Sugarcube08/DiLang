# Feature Contract 04 — Learning Engine & Orchestrator

**Feature Name:** Learning Engine, Mission Generator, Session Lifecycle & Recommendation Coaching Engine  
**Sprint:** Sprint 4 — Phase 1 (Product Implementation)  
**Status:** Approved Feature Contract  
**Target Packages:** `packages/learning_engine`, `packages/memory`, `packages/storage`, `packages/application`, `packages/product_ui`, `apps/desktop`

---

## 1. Business Purpose & Operating System Vision

Transform DiLang from a passive progress tracker into an **AI-native language learning operating system**. The system continuously plans, adapts, and coaches—evaluating FSRS 4.5 memory decay, weak grammar patterns, available time (5m, 15m, 30m), and CEFR goals to generate exactly ONE primary daily mission and actionable coaching guidance.

---

## 2. Learning Engine Architecture

```
[ FSRS 4.5 Memory Engine ] [ Knowledge Graph ] [ SQLite Event Store ] [ User Goals ]
                                    │
                                    ▼
                      [ Learning Analytics Engine ]
                                    │
                                    ▼
                       [ Learning Orchestrator ]
                                    │
                                    ▼
                      [ Adaptive Mission Generator ]
                                    │
                                    ▼
                    [ Unified Session Lifecycle Engine ]
                                    │
                                    ▼
                   [ TodayDashboardUseCase & ViewModel ]
```

---

## 3. Core Domain Entities (`packages/learning_engine`)

```dart
enum SessionLifecycleState {
  idle,
  started,
  paused,
  resumed,
  completed,
  evaluated,
  persisted,
}

enum AvailableTimeSlot {
  quick5Min,
  standard15Min,
  deep30Min,
}

class CoachingRecommendation extends Equatable {
  final String id;
  final String title;
  final String explanation;
  final String weakConcept; // e.g. "der vs den accusative case"
  final String suggestedAction;
  final DateTime generatedAt;

  const CoachingRecommendation({
    required this.id,
    required this.title,
    required this.explanation,
    required this.weakConcept,
    required this.suggestedAction,
    required this.generatedAt,
  });
}

class GeneratedMission extends Equatable {
  final String missionId;
  final String title;
  final String description;
  final int totalDurationMinutes;
  final String targetLanguage;
  final String cefrLevel;
  final int dueVocabularyCount;
  final String primaryActivityType; // "conversation", "review", "grammar"
  final CoachingRecommendation coaching;

  const GeneratedMission({
    required this.missionId,
    required this.title,
    required this.description,
    required this.totalDurationMinutes,
    required this.targetLanguage,
    required this.cefrLevel,
    required this.dueVocabularyCount,
    required this.primaryActivityType,
    required this.coaching,
  });
}
```

---

## 4. Session Engine Lifecycle (`packages/learning_engine`)

```
[ Session.start() ] ──▶ [ State: STARTED ]
                             │
                             ▼
[ Session.complete(metrics) ] ──▶ [ State: COMPLETED ]
                                        │
                                        ▼
[ Session.evaluate() ] ──▶ [ State: EVALUATED (FSRS 4.5 + Retention calculated) ]
                                        │
                                        ▼
[ Session.persist() ] ──▶ [ State: PERSISTED (Event emitted to SQLite domain_event_store) ]
                                        │
                                        ▼
[ Orchestrator.recalculate() ] ──▶ [ State: RECOMMENDATIONS UPDATED ]
```

---

## 5. Unified Domain Event System (`packages/core` & `packages/storage`)

Domain Events emitted to SQLite `domain_event_store`:
- `MissionStartedEvent`
- `LessonCompletedEvent`
- `ReviewCompletedEvent`
- `HealthChangedEvent`
- `GoalAchievedEvent`
- `VocabularyLearnedEvent`
- `GrammarUnlockedEvent`

---

## 6. Performance Budget & Acceptance Criteria

- **Mission Generation Latency**: `< 50 ms` (evaluating FSRS cards + weak skills + adaptive planner).
- **Session Lifecycle Transitions**: Zero UI thread blocking during evaluation & event log persistence.
- **Acceptance Scenario**:
  1. Orchestrator evaluates learner's FSRS due cards, weak grammar skills, and available time (e.g. 15 mins).
  2. Mission Generator outputs exactly ONE primary mission with a specific coaching recommendation (*"You consistently confuse der and den. Today's conversation will reinforce this naturally"*).
  3. Learner starts mission → `SessionEngine` enters `STARTED` state.
  4. Learner completes mission → `SessionEngine` transitions through `COMPLETED` → `EVALUATED` → `PERSISTED`.
  5. `domain_event_store` appends `LessonCompletedEvent` and `HealthChangedEvent`.
  6. Dashboard immediately projects new mission, updated health scorecard, and refreshed coaching insights.
