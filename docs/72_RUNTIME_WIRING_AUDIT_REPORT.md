# 72. Runtime Wiring Audit Report — Phase Ω.4

**Document Version:** 1.0.0  
**Status:** Audit Complete (Zero Code Modifications / Pure Execution Tracing)  
**Scope:** Runtime Execution Paths & Interaction Call Graphs across `apps/desktop` and `packages/*`

---

## Executive Summary

The **Runtime Wiring Audit** confirms that while all underlying domain engines, SQLite repositories, and Riverpod providers exist and pass unit tests, **the running Flutter application contains key runtime execution breaks where user interactions bypass interactive session execution**.

---

## Execution Path Traces & Runtime Call Graphs

### Interaction 1: Application Cold Startup & Bootstrap Sequence
```
User Launches App
       │
       ▼
main() [apps/desktop/lib/main.dart]
       │
       ▼
ProviderScope [Riverpod Root]
       │
       ▼
DiLangAppEntry.build()
       │
       ▼
ref.watch(bootstrapResultProvider)
       │
       ▼
BootstrapPipeline.runPipeline() [packages/application]
       │ (Stage 1: Platform -> Stage 3: SQLite -> Stage 7: Identity)
       ▼
SQLite Database Opened (`dilang_storage.db`)
       │
       ▼
BootstrapResult (status: onboardingRequired OR authenticatedReady)
       │
       ▼
MaterialApp Home Rebuild (FtueWizardScreen OR TodayDashboardMainShell)
```
- **UI Event**: App Launch
- **Callback**: `main()` → `DiLangAppEntry.build()`
- **Controller/Notifier**: `bootstrapResultProvider` (FutureProvider)
- **Use Case**: `BootstrapAppUseCase` / `BootstrapPipeline`
- **Domain Service**: `CoreKernel`
- **Repository**: `SqliteBootstrapRepository`, `SqliteIdentityRepository`
- **Database Operation**: `SELECT * FROM users;`, `PRAGMA foreign_keys = ON;`
- **Event Emitted**: None (`BootstrapResult` returned)
- **State Update**: `AsyncValue.data(BootstrapPipelineResult)`
- **Widget Rebuild**: `DiLangAppEntry` rebuilds `home` widget
- **Visible Result**: Glassmorphic Loading Screen → Onboarding Wizard OR Today Dashboard Shell
- **Status**: **CONNECTED** ✅

---

### Interaction 2: FTUE Onboarding Wizard Submission
```
User Types Username & Clicks "Complete Setup & Start Learning →"
       │
       ▼
onPressed Callback [FtueWizardScreen lines 117-118]
       │
       ▼
FtueNotifier.completeOnboarding() [packages/product_ui]
       │
       ▼
CreateIdentityUseCase.execute(...) [packages/application]
       │
       ▼
SqliteIdentityRepository.saveUser(...) [packages/storage]
       │
       ▼
SQLite Database Operation: `INSERT INTO users ...;`
       │
       ▼
ref.invalidate(bootstrapResultProvider)
       │
       ▼
BootstrapPipeline re-executes → Status: authenticatedReady
       │
       ▼
DiLangAppEntry rebuilds → Displays TodayDashboardMainShell
```
- **UI Event**: Button Tap ("Complete Setup")
- **Callback**: `onPressed: () => notifier.completeOnboarding()`
- **Controller/Notifier**: `FtueNotifier` (StateNotifier)
- **Use Case**: `CreateIdentityUseCase`
- **Domain Service**: `FtueOnboardingController`
- **Repository**: `SqliteIdentityRepository`
- **Database Operation**: `INSERT INTO users ...`, `INSERT INTO profiles ...`
- **Event Emitted**: None
- **State Update**: `FtueStep.completed` & `bootstrapResultProvider` invalidated
- **Widget Rebuild**: `DiLangAppEntry` switches to `TodayDashboardMainShell`
- **Visible Result**: Transition from Onboarding Wizard to Today Dashboard
- **Status**: **CONNECTED** ✅

---

### Interaction 3: "Today's Mission" Hero Button Click
```
User Clicks "Today's Mission: Conversation Practice" Hero Button
       │
       ▼
InkWell.onTap Callback [dilang_app.dart lines 230-236]
       │
       ▼
ref.read(todayDashboardNotifierProvider.notifier).recordSessionCompleted(...)
       │
       ▼
TodayDashboardUseCase.recordCompletedSession(...) [packages/application]
       │
       ▼
SqliteIdentityRepository.saveUser(...) [packages/storage]
       │
       ▼
SQLite Database Operation: `UPDATE users SET updated_at = ...`
       │
       ▼
TodayDashboardNotifier.loadDashboard()
       │
       ▼
Dashboard Widget Rebuilds (+1 Completed Session Count)
```
- **UI Event**: Button Tap ("Today's Mission")
- **Callback**: `onTap: () async { await ref.read(...).recordSessionCompleted(...); }`
- **Controller/Notifier**: `TodayDashboardNotifier`
- **Use Case**: `TodayDashboardUseCase`
- **Domain Service**: **MISSING** (Bypasses `DialogueManager` & `LearningSession`!)
- **Repository**: `SqliteIdentityRepository`
- **Database Operation**: `UPDATE users ...`
- **Event Emitted**: **MISSING** (`SessionStarted`, `SessionCompleted` never emitted)
- **State Update**: `TodayDashboardViewModel` reloaded
- **Widget Rebuild**: `TodayDashboardMainShell` rebuilds
- **Visible Result**: Scorecard increments without running dialogue session
- **Status**: **STUBBED / BROKEN LINK** ❌ (Bypasses interactive dialogue execution)

---

### Interaction 4: Sidebar Navigation Tab Switch
```
User Clicks "Voice AI Dialogue" Sidebar Tab
       │
       ▼
InkWell.onTap Callback [_SidebarItem lines 388]
       │
       ▼
ref.read(activeTabProvider.notifier).state = 2
       │
       ▼
activeTabProvider emits `2`
       │
       ▼
TodayDashboardMainShell Rebuilds -> Displays VoiceDialogueSection
```
- **UI Event**: Sidebar Tab Tap
- **Callback**: `onTap: () => ref.read(activeTabProvider.notifier).state = index`
- **Controller/Notifier**: `activeTabProvider` (StateProvider<int>)
- **Use Case**: None (Pure Navigation)
- **Domain Service**: None
- **Repository**: None
- **Database Operation**: None
- **Event Emitted**: None
- **State Update**: `activeTab = 2`
- **Widget Rebuild**: `TodayDashboardMainShell`
- **Visible Result**: Workspace switches to `VoiceDialogueSection`
- **Status**: **CONNECTED** ✅

---

### Interaction 5: Voice AI Dialogue Turn Execution (`VoiceDialogueSection`)
```
User Views VoiceDialogueSection
       │
       ▼
Static Render of `BuiltInScenarios.ScenarioCafeVienna` [dilang_app.dart lines 470-498]
       │
       ▼
No Text Input / No Mic Listening / No Interactive Button
       │
       ▼
[DEAD END - Execution Stops]
```
- **UI Event**: User attempts to speak or type a response
- **Callback**: **MISSING** (No `TextField` or speech input listener)
- **Controller/Notifier**: **MISSING**
- **Use Case**: **MISSING** (`DialogueManager.processTurn()` is never invoked by UI)
- **Domain Service**: `DialogueManager` (Uncalled by UI)
- **Repository**: `SqliteReplayRepository` (Unwritten by UI)
- **Database Operation**: `INSERT INTO replay_transcripts ...` (Unexecuted by UI)
- **Event Emitted**: `TurnCompleted`, `EvaluationCompleted` (Unemitted)
- **State Update**: None
- **Widget Rebuild**: None
- **Visible Result**: Static text card showing cultural note
- **Status**: **DEAD END / BROKEN LINK** ❌

---

### Interaction 6: Knowledge Graph Inspection (`VocabularyGraphSection`)
```
User Clicks "Vocabulary Web" Sidebar Tab
       │
       ▼
UniversalKnowledgeGraph.createGermanA1Graph() [dilang_app.dart line 440]
       │
       ▼
ListView.builder renders 4 KnowledgeNode Cards
```
- **UI Event**: Sidebar Tab Click
- **Callback**: `activeTabProvider = 1`
- **Controller/Notifier**: `activeTabProvider`
- **Use Case**: None (Direct Graph Query)
- **Domain Service**: `UniversalKnowledgeGraph`
- **Repository**: `SqliteIntelligenceRepository` (Unused by UI)
- **Database Operation**: None
- **Event Emitted**: None
- **State Update**: UI tab switch
- **Widget Rebuild**: `VocabularyGraphSection`
- **Visible Result**: Renders German A1 Knowledge Graph nodes (`node_art_der`, `node_acc_masc`, etc.)
- **Status**: **CONNECTED (READ-ONLY)** ⚠️

---

## Summary of Runtime Execution Breaks

| # | Interaction Path | Runtime Status | Root Cause of Execution Break |
| :-: | :--- | :---: | :--- |
| **1** | Startup & Bootstrap | **CONNECTED** ✅ | Pipeline executes cleanly, opens SQLite, loads user identity. |
| **2** | FTUE Onboarding Submission | **CONNECTED** ✅ | `CreateIdentityUseCase` writes to SQLite and invalidates bootstrap state. |
| **3** | Hero Mission Button Tap | **BROKEN LINK** ❌ | `onTap` directly calls `recordCompletedSession` instead of launching `DialogueManager` session. |
| **4** | Sidebar Navigation Tabs | **CONNECTED** ✅ | Riverpod `activeTabProvider` switches view sections cleanly. |
| **5** | Voice AI Dialogue View | **DEAD END** ❌ | UI renders static text; lacks turn input controls to execute `DialogueManager.processTurn()`. |
| **6** | Knowledge Graph View | **READ-ONLY** ⚠️ | Renders static graph nodes; lacks interactive node mastery expansion. |

---

### Master Runtime Audit Conclusion

The application runtime architecture is **conceptually connected**, but **Interaction 3 (Hero Button)** and **Interaction 5 (Voice Dialogue View)** contain runtime breaks where interactive turn execution (`DialogueManager.processTurn()`) is bypassed. Fixing these two specific callbacks will complete 100% of the runtime execution chain.
