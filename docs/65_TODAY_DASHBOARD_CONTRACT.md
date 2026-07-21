# Feature Contract 03 — Today Dashboard Experience & Composition Layer

**Feature Name:** "Today" Mission Control Dashboard Experience  
**Sprint:** Sprint 3 — Phase 1 (Product Implementation)  
**Status:** Approved Feature Contract  
**Target Packages:** `packages/learner`, `packages/language`, `packages/memory`, `packages/learning_engine`, `packages/storage`, `packages/application`, `packages/product_ui`, `apps/desktop`

---

## 1. Business Purpose & Experience Goal

When a learner opens DiLang every morning, they immediately see a single personalized primary action ("Continue Today's Session"), an 8-axis Language Health scorecard, an interactive timeline narrative of their learning journey, and a single targeted linguistic insight—all generated directly from real SQLite database tables and the FSRS 4.5 memory engine.

---

## 2. Dashboard Composition Architecture

```
[ LearningEngine ] [ HealthRepo ] [ EventStore ] [ VocabularyRepo ] [ Fsrs45Engine ]
                               │
                               ▼
                    [ TodayDashboardUseCase ]
                               │
                               ▼
                   [ TodayDashboardViewModel ]
                               │
                               ▼
                   [ TodayDashboardView (UI) ]
```

---

## 3. Immutable Data Contracts (`packages/application`)

```dart
class HealthScorecardViewModel {
  final int overallScore; // 0 to 100
  final int vocabularyScore;
  final int grammarScore;
  final int fluencyScore;
  final double retentionRate; // e.g. 0.94 (94%)
  final String statusText; // "Optimal Recovery", "Review Needed"

  const HealthScorecardViewModel({
    required this.overallScore,
    required this.vocabularyScore,
    required this.grammarScore,
    required this.fluencyScore,
    required this.retentionRate,
    required this.statusText,
  });
}

class TodayMissionViewModel {
  final String title; // "Conversation Practice"
  final String subTitle; // "Ordering at a Viennese Café"
  final int estimatedMinutes; // 12
  final String targetLanguage; // "German"
  final String cefrLevel; // "A1"
  final int dueReviewsCount; // 14

  const TodayMissionViewModel({
    required this.title,
    required this.subTitle,
    required this.estimatedMinutes,
    required this.targetLanguage,
    required this.cefrLevel,
    required this.dueReviewsCount,
  });
}

class TimelineItemViewModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String type; // "review", "conversation", "milestone"

  const TimelineItemViewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}

class TodayDashboardViewModel {
  final String greeting;
  final String username;
  final int currentStreak;
  final TodayMissionViewModel mission;
  final HealthScorecardViewModel health;
  final List<TimelineItemViewModel> timeline;
  final String singleInsight;
  final bool isLoading;
  final String? errorMessage;

  const TodayDashboardViewModel({
    required this.greeting,
    required this.username,
    required this.currentStreak,
    required this.mission,
    required this.health,
    required this.timeline,
    required this.singleInsight,
    this.isLoading = false,
    this.errorMessage,
  });
}
```

---

## 4. Dashboard Repositories & Engine Data Sources

| Section / Widget | Backing Repository & Engine |
| :--- | :--- |
| **Greeting & User Identity** | `IdentityRepositoryContract` (SQLite `users`, `profiles`) |
| **Streak & Daily Mission** | `LearningEngine` & `LearnerRepositoryContract` |
| **Language Health Scorecard** | `HealthRepository` (calculated from FSRS 4.5 stability + accuracy) |
| **Memory Health & Reviews** | `Fsrs45Engine` & `VocabularyRepositoryContract` |
| **Timeline Narrative** | `EventStoreRepositoryContract` (SQLite `domain_event_store`) |
| **Single Linguistic Insight** | `RecommendationEngine` (evaluates weak CEFR skills) |

---

## 5. UI Layout & Multi-State Support

- **Hero Card**: Primary action button `[ Continue Today's Session → ]` with micro-pulse gradient halo.
- **Health Scorecard**: Compact 8-axis ring gauge with single-tap modal expansion for detailed metrics.
- **Timeline Narrative**: Vertical timeline card showing completed lessons and retention gains.
- **Multi-State Support**: Full support for `Loading` (skeleton shimmer), `Empty` (first-day welcome mission), `Offline` (cached SQLite state), and `Error` (graceful retry card).

---

## 6. Performance Budgets & Acceptance Criteria

- **First Contentful Paint**: `≤ 300 ms` on baseline desktop/mobile hardware.
- **Scroll & Transitions**: Locked `60 FPS` during scroll and section expands.
- **Acceptance Scenario**:
  1. Onboarding completed → App opens Today.
  2. Dashboard loads real user identity, health score, and mission from SQLite.
  3. User completes a lesson → `EventStoreRepository` appends completion event.
  4. Returning to Today immediately updates streak, timeline, and health metrics.
  5. Relaunching the application restores identical state with 0 lost data.
