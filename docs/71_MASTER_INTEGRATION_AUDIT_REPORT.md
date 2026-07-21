# 71. Master Integration Audit Report — Phase Ω.1 (v1.0.0-alpha Baseline)

**Document Version:** 1.0.0  
**Status:** Audit Complete (Zero Code Changes / Pure Integration Verification)  
**Scope:** `apps/desktop`, `apps/mobile`, and `packages/*`

---

## 1. Working Systems

The following backend infrastructure, algorithms, database tables, and use cases pass 100% unit and integration tests:

1. **`packages/storage` Core SQLite Engine (`SqliteStorageEngine`)**:
   - SQLite table DDL (`users`, `profiles`, `language_profiles`, `sync_accounts`, `sync_change_log`, `settings`, `replay_transcripts`, `cognitive_models`, `error_intelligence`, `schema_migrations`).
   - SQLite foreign keys (`PRAGMA foreign_keys = ON;`), WAL mode, indices, corruption check, auto-repair, and transaction rollback.
   - `SqliteIdentityRepository`, `SqliteReplayRepository`, `SqliteIntelligenceRepository`, and `SqliteBootstrapRepository`.
   - `MemorySecureStorage` key management for encryption keys and sync tokens.
2. **`packages/application` Bootstrap & Dashboard Engine**:
   - `BootstrapPipeline`: 9-stage startup pipeline (`Platform`, `Logging`, `SQLite`, `SecureStorage`, `Repositories`, `Settings`, `Identity`, `Localization`, `Navigation`) with timing telemetry (<20ms).
   - `CreateIdentityUseCase` & `BootstrapAppUseCase`.
   - `TodayDashboardUseCase` & `TodayDashboardViewModel`.
   - `FtueOnboardingController` 10-screen state machine (`Welcome` → `Completed`).
3. **`packages/learning_engine` Memory & Intelligence Engine**:
   - `Fsrs45Engine`: FSRS 4.5 retrievability math calculations.
   - `MissionGenerator` & `CoachingRecommendation`: Adaptive time-slot mission generator (5m, 15m, 30m).
   - `LearningSession`: 7-stage session lifecycle engine (`idle` → `persisted`).
   - `LearnerIntelligenceEngine`: Multi-dimensional cognitive model inference & error cause analysis.
   - `AutomatedEvaluationFramework`: 5-gate educational regression suite.
4. **`packages/conversation` Dialogue Engine**:
   - `DialogueManager`: Context, persona, and turn processing.
   - `BuiltInScenarios`: Scenario metadata catalog (`scn_cafe_vienna`, `scn_doctor_berlin`).
   - `DeclarativeScenarioManifest`: JSON/YAML scenario manifest parser.
   - `LearningReplayTranscript`: Turn-by-turn replay data model.
5. **`packages/language` Knowledge Graph**:
   - `UniversalKnowledgeGraph` & `KnowledgeNode`: Weighted directed graph prerequisites.

---

## 2. Disconnected Systems

The following systems exist in packages but are disconnected from the application entry point (`apps/desktop/lib/main.dart`):

1. **`BootstrapPipeline` ↔ Flutter UI Application**: `main.dart` instantiates `AppLifecycleController.createDefault()` but does NOT execute or await `BootstrapPipeline.runPipeline()`.
2. **`TodayDashboardUseCase` ↔ `DiLangLanguageOsApp` UI**: `main.dart` reads hardcoded static `const TodayDashboardState()` instead of querying `TodayDashboardUseCase.loadDashboard()`.
3. **`SqliteStorageEngine` ↔ Presentation Layer**: SQLite repositories are initialized in test suites but NOT injected or provided via Riverpod to the Flutter widget tree.
4. **`FtueOnboardingController` ↔ App Startup Flow**: Onboarding wizard state machine is NOT wired to app entry routing; launching the desktop app bypasses FTUE entirely even when no user exists in SQLite.
5. **`DialogueManager` ↔ Voice AI Dialogue UI**: Dialogue manager and replay transcript logging are disconnected from the desktop sidebar `Voice AI Dialogue` navigation.
6. **`LearnerIntelligenceEngine` ↔ Today Scorecard**: The WHOOP-style scorecard tiles in `main.dart` display hardcoded strings (`'+14%'`, `'+18%'`, `'+92%'`) instead of consuming `LearnerCognitiveModel` from `SqliteIntelligenceRepository`.

---

## 3. Dead Code

1. **`packages/product_ui/lib/src/today/today_dashboard_state.dart`**: Contains duplicate static `TodayDashboardState` and `TodayScorecard` models that conflict with `TodayDashboardViewModel` in `packages/application`.
2. **`packages/storage/lib/src/repositories/in_memory_repository.dart`**: Obsolete in-memory repository file replaced by production SQLite repositories.
3. **`packages/product_ui/lib/src/onboarding/first_run_onboarding_controller.dart`**: Obsolete onboarding controller superseded by `FtueOnboardingController` in `packages/application`.

---

## 4. Mock Implementations

1. **`apps/desktop/lib/main.dart` (Lines 20–21)**:
   - `const todayState = TodayDashboardState();` (Hardcoded mock state).
   - `VocabularyKnowledgeGraph.sampleFoodGraph();` (Hardcoded mock vocabulary list).
2. **`apps/desktop/lib/main.dart` (Lines 185–218)**:
   - `_ScorecardTile` widgets render hardcoded string constants (`Learning Load: Target Balance`, `Memory Gain: +14%`, `Pronunciation: +18%`, `Vocabulary: +92`) rather than live SQLite data.
3. **`apps/desktop/lib/main.dart` (Lines 256–274)**:
   - 30-Day Language Evolution Story renders hardcoded text strings (*"You have learned 142 words"*).

---

## 5. Broken Navigation

1. **Sidebar Items (`apps/desktop/lib/main.dart`)**:
   - `_NavItem` widgets (Vocabulary Web, Voice AI Dialogue, Language Health, AI Engine Setup, Settings) are static `Row` elements without `onTap` callbacks or `Navigator` / `Router` navigation bindings.
2. **"Today's Mission: Conversation" Hero Button (`apps/desktop/lib/main.dart` Lines 144–166)**:
   - Rendered as a non-interactive `Container` without an `InkWell`, `GestureDetector`, or route trigger to launch `DialogueManager`.

---

## 6. Broken Dependency Injection

1. **Missing Service Locator / Riverpod Container at Root**: `main.dart` does not wrap `MaterialApp` in a `ProviderScope` (Riverpod) or dependency injection scope.
2. **Uninjected Repositories**:
   - `SqliteIdentityRepository`
   - `SqliteBootstrapRepository`
   - `SqliteReplayRepository`
   - `SqliteIntelligenceRepository`
   - `TodayDashboardUseCase`
   - `FtueOnboardingController`
   - `LearningEngineOrchestrator`

None of these singletons or providers are registered in `main.dart`.

---

## 7. Broken State Flow

1. **App Relaunch State Loss**: Because `main.dart` reads hardcoded constants, closing and reopening the app always resets the UI to the same static state regardless of SQLite updates.
2. **Session Completion Unreflected**: Calling `recordCompletedSession` in `TodayDashboardUseCase` updates SQLite, but because `main.dart` has no Riverpod state notifier listening to the database, the UI does not refresh.

---

## 8. Broken Persistence

1. **Desktop App Writes to DB**: The Flutter Desktop UI never invokes `saveUser`, `markOnboardingCompleted`, or `saveTranscript` during runtime interaction because no use case is connected to the UI.

---

## 9. Broken UI Bindings

1. `main.dart` Line 130: `Good Morning, ${todayState.learnerName}` reads hardcoded `'Alex Learner'` instead of `DiLangUser.profile.displayName`.
2. `main.dart` Line 139: `'German (de-DE) • Streak: 32 Days 🔥'` reads hardcoded string instead of `TodayDashboardViewModel.currentStreak` and `primaryLanguageProfile`.
3. `main.dart` Lines 309–352: Vocabulary Web tile renders sample food graph instead of `UniversalKnowledgeGraph.allNodes`.

---

## 10. Critical Blocking Issues

1. **`main.dart` Static Scaffolding Bypass**: The entire production architecture (BootstrapPipeline, SQLite, FSRS 4.5, DialogueManager, Intelligence Engine) is bypassed by a static layout demo inside `apps/desktop/lib/main.dart`.
2. **Missing `ProviderScope` & Navigation Router**: The app cannot navigate between Onboarding, Today Dashboard, and Conversation screens.

---

## 11. Priority Fix Order

| # | Severity | Affected Modules | Root Cause | Required Fix | Estimated Complexity |
| :-: | :--- | :--- | :--- | :--- | :---: |
| **1** | **CRITICAL** | `apps/desktop/lib/main.dart`, `packages/application` | `main.dart` does not execute `BootstrapPipeline` or wrap app in Riverpod `ProviderScope`. | Wire `BootstrapPipeline.runPipeline()` at `main()`, wrap root in `ProviderScope`, and initialize SQLite storage engine. | **Medium** |
| **2** | **CRITICAL** | `apps/desktop/lib/main.dart`, `packages/application` | App entry lacks routing logic between FTUE Onboarding and Today Dashboard. | Implement router checking `BootstrapResult.status` (`onboardingRequired` → `FtueWizardView`, `authenticatedReady` → `TodayDashboardView`). | **Medium** |
| **3** | **HIGH** | `apps/desktop/lib/main.dart`, `packages/product_ui` | Sidebar `_NavItem` widgets have zero navigation callbacks. | Add Riverpod-driven navigation state switcher for Today, Vocabulary Graph, Voice Dialogue, Health, and Settings. | **Low** |
| **4** | **HIGH** | `packages/product_ui`, `packages/application` | Today Dashboard renders static strings instead of `TodayDashboardViewModel`. | Bind `TodayDashboardView` to a Riverpod `StateNotifierProvider` consuming `TodayDashboardUseCase.loadDashboard()`. | **Medium** |
| **5** | **HIGH** | `apps/desktop/lib/main.dart`, `packages/conversation` | "Today's Mission" button does not launch conversation session. | Wire Hero CTA button to instantiate `DialogueManager(scenario: BuiltInScenarios.ScenarioCafeVienna)` and launch conversation stage. | **Medium** |
| **6** | **MEDIUM** | `packages/product_ui`, `packages/learning_engine` | WHOOP scorecard tiles read static strings instead of `LearnerCognitiveModel`. | Wire scorecard tiles to `SqliteIntelligenceRepository` and FSRS retrievability metrics. | **Low** |
| **7** | **LOW** | `packages/product_ui`, `packages/storage` | Obsolete in-memory and stub state files exist in `packages/product_ui` and `packages/storage`. | Delete `in_memory_repository.dart`, `first_run_onboarding_controller.dart`, and `today_dashboard_state.dart`. | **Low** |

---

### Audit Sign-Off

The Master Integration Audit (Phase Ω.1) is complete. Zero code modifications were performed during this audit. This report serves as the master specification for **Phase Ω.2 System Integration**.
