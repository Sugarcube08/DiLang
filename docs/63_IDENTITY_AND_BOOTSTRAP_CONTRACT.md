# Feature Contract 01 — Identity & Bootstrap Vertical Slice

**Feature Name:** Identity & Application Bootstrap  
**Sprint:** Sprint 1 — Phase 1 (Product Implementation)  
**Status:** Approved Feature Contract  
**Target Packages:** `packages/core`, `packages/storage`, `packages/learner`, `packages/application`, `packages/product_ui`, `apps/desktop`, `apps/mobile`

---

## 1. Business Purpose

Establish a durable, offline-first learner identity (`DiLangID`), local encryption keys, device registration, language preferences, sync change queue, and a deterministic startup sequence. This guarantees every subsequent feature (Dashboard, Conversation, SRS, Health) consumes real, persisted user state.

---

## 2. Domain Models (`packages/learner` & `packages/core`)

Immutable Value Objects and Entities with zero `dynamic` types:

```dart
// Core Identity Entities
class UserId { final String value; }
class DeviceId { final String value; }

class DiLangUser {
  final UserId id;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final SyncAccount syncAccount;
}

class Device {
  final DeviceId id;
  final String deviceName;
  final String platform; // "linux", "macos", "windows", "ios", "android", "web"
  final DateTime registeredAt;
}

class Profile {
  final UserId userId;
  final String displayName;
  final String avatarUrl;
  final String nativeLanguage; // ISO 639-1 (e.g. "en", "es")
  final String timezone;
}

class LanguageProfile {
  final String id;
  final UserId userId;
  final String targetLanguage; // ISO 639-1 (e.g. "de", "ja", "fr")
  final String cefrLevel; // "A1", "A2", "B1", "B2", "C1", "C2"
  final String learningGoal; // "fluency", "travel", "career", "culture"
  final int dailyGoalMinutes;
  final bool isPrimary;
}

class SyncAccount {
  final String syncId;
  final bool isSyncEnabled;
  final DateTime? lastSyncedAt;
  final String syncStatus; // "idle", "syncing", "error", "disabled"
}
```

---

## 3. Database Schema (`packages/storage` - Drift / SQLite)

Production Tables in SQLite database `dilang_local.db`:

- `users` (id TEXT PRIMARY KEY, username TEXT, email TEXT, created_at INTEGER, last_active_at INTEGER)
- `devices` (id TEXT PRIMARY KEY, user_id TEXT, device_name TEXT, platform TEXT, registered_at INTEGER)
- `profiles` (user_id TEXT PRIMARY KEY, display_name TEXT, avatar_url TEXT, native_language TEXT, timezone TEXT)
- `language_profiles` (id TEXT PRIMARY KEY, user_id TEXT, target_language TEXT, cefr_level TEXT, learning_goal TEXT, daily_goal_minutes INTEGER, is_primary INTEGER)
- `sync_accounts` (sync_id TEXT PRIMARY KEY, user_id TEXT, is_sync_enabled INTEGER, last_synced_at INTEGER, sync_status TEXT)
- `sync_change_log` (id TEXT PRIMARY KEY, entity_type TEXT, entity_id TEXT, action TEXT, payload TEXT, timestamp INTEGER, synced INTEGER)
- `settings` (key TEXT PRIMARY KEY, value TEXT, updated_at INTEGER)

---

## 4. Repository Contracts & Implementation

- `IdentityRepositoryContract`:
  - `Future<DiLangUser?> getActiveUser()`
  - `Future<void> saveUser(DiLangUser user, Profile profile, LanguageProfile languageProfile)`
  - `Future<List<LanguageProfile>> getLanguageProfiles(UserId userId)`
  - `Future<void> updateActiveLanguage(UserId userId, String targetLanguage)`

- `BootstrapRepositoryContract`:
  - `Future<bool> isFirstLaunch()`
  - `Future<void> markOnboardingCompleted()`
  - `Future<Map<String, String>> loadSystemSettings()`

---

## 5. Use Cases (`packages/application`)

1. `BootstrapAppUseCase`: Executes startup pipeline in strict order. Returns `BootstrapState` (`uninitialized`, `onboardingRequired`, `authenticatedReady`, `failed`).
2. `CreateIdentityUseCase`: Validates inputs, creates user keypair, persists `DiLangUser`, `Profile`, and initial `LanguageProfile` to SQLite.
3. `InitializeSyncQueueUseCase`: Bootstraps local change log table and provisions zero-knowledge sync queue.

---

## 6. State Management (Riverpod 2.x `@riverpod`)

- `BootstrapNotifier`: Manages `AsyncValue<BootstrapResult>`.
- `ActiveUserNotifier`: Holds immutable `DiLangUser?` state.
- `OnboardingFlowNotifier`: State machine for guided onboarding wizard (`stepWelcome`, `stepIdentity`, `stepSync`, `stepLanguages`, `stepGoal`, `stepAiDownload`, `stepComplete`).

---

## 7. Navigation Flow

```
[ App Launch ] ──▶ [ Bootstrap Phase ]
                         │
        ┌────────────────┴────────────────┐
        ▼                                 ▼
[ Onboarding Route ]             [ Today Dashboard Route ]
 (if isFirstLaunch)              (if user exists in SQLite)
```

---

## 8. UI Components (`packages/product_ui` & `packages/design_system`)

- `OnboardingWizardScreen`: Step container with progress bar, smooth page transitions, and keyboard navigation.
- `IdentityFormStep`: Custom input fields with validation and error states.
- `LanguageSelectorStep`: Grid of supported languages with duotone flags and native labels.
- `GoalSelectorStep`: Card options for daily targets (10m, 15m, 30m, 45m).
- `AiModelProvisioningStep`: "Recommended AI (Runs Offline, 3.4 GB)" card with download progress bar.

---

## 9. Accessibility & Motion

- **Semantics**: Screen-reader accessible step titles, announcements on step changes, high-contrast inputs.
- **Motion**: `300ms cubic-bezier(0.2, 0.8, 0.2, 1)` forward/backward slide transitions between steps.

---

## 10. Performance Budget & Testing

- **Startup Execution**: Platform + Database + Identity load `< 200 ms`.
- **Testing**:
  - Unit tests for `IdentityRepository`, `BootstrapAppUseCase`, and `Fsrs45Engine`.
  - Integration tests for Fresh Install → Onboarding → SQLite Write → Today Dashboard state transition.
  - Zero analyzer warnings (`flutter analyze`).

---

## 11. Definition of Done

1. Domain entities & SQLite Drift tables compiled without warnings.
2. Production `IdentityRepository` reads/writes real SQLite database.
3. Ordered startup pipeline runs synchronously on app launch.
4. Onboarding wizard completes and writes real `DiLangUser` & `LanguageProfile` to SQLite.
5. Launching app second time bypasses onboarding directly to Today Dashboard backed by real `ActiveUserNotifier`.
