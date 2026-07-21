# Feature Contract 02 — First-Time User Experience (FTUE) & Capability Registry

**Feature Name:** First-Time User Experience (FTUE) Onboarding Companion & Capability Registry  
**Sprint:** Sprint 2 — Phase 1 (Product Implementation)  
**Status:** Approved Feature Contract  
**Target Packages:** `packages/core`, `packages/storage`, `packages/application`, `packages/design_system`, `packages/product_ui`, `apps/desktop`

---

## 1. Business Purpose

Establish trust within 5 minutes of installation by guiding the learner through a zero-jargon, 1-decision-per-screen companion flow. Persists DiLang ID, local encryption keys, offline/sync preferences, language profile, learning goals, and offline AI/language resource manifests directly to SQLite before transitioning to the Today Dashboard.

---

## 2. Capability Registry & Feature Flags (`packages/core`)

```dart
enum CapabilityKey {
  offlineAiRuntime,
  cloudSyncEngine,
  diagnosticAssessment,
  speechSynthesis,
  phoneticAudio,
}

class CapabilityManifest {
  final CapabilityKey key;
  final bool isEnabled;
  final bool isExperimental;
  final String minSupportedVersion;

  const CapabilityManifest({
    required this.key,
    required this.isEnabled,
    this.isExperimental = false,
    required this.minSupportedVersion,
  });
}
```

---

## 3. FTUE State Machine & Navigation Graph (`packages/product_ui` & `packages/application`)

```
[ Screen 0: Bootstrap ] ──(Needs Onboarding)──▶ [ Screen 1: Welcome ]
                                                         │
                                                         ▼
[ Screen 3: Sync ] ◀───────(Create ID)───────── [ Screen 2: Identity ]
       │
       ▼
[ Screen 4: Languages ] ──▶ [ Screen 5: Goal ] ──▶ [ Screen 6: Starting Point ]
                                                              │
                                                              ▼
[ Screen 8: Resources ] ◀─────(Install Brain)──── [ Screen 7: AI Setup ]
       │
       ▼
[ Screen 9: Success ] ───(Start Learning)───▶ [ Today Dashboard ]
```

---

## 4. UI Screen Breakdown & UX Specifications

- **Screen 0 — Bootstrap**: Hidden/minimal loading indicator; checks SQLite integrity and triggers Recovery UI if database is corrupted.
- **Screen 1 — Welcome**: "DiLang: Learn a language that stays with you." Single CTA button `[ Get Started ]`.
- **Screen 2 — Identity**: Username, Password, optional Email with security badge explaining zero-knowledge encryption.
- **Screen 3 — Sync**: Choice between `[ Enable Sync ]` (encrypted cross-device) and `[ Continue Offline ]`.
- **Screen 4 — Languages**: "I speak [English]" → "I want to learn [German]". Single dropdown/chip selector.
- **Screen 5 — Goal**: One-tap goal card selection (Work, Study, Travel, Relocation, Conversation).
- **Screen 6 — Starting Point**: Choice between `[ Take 3-Minute Assessment ]` or `[ Start from Beginning ]`.
- **Screen 7 — AI Setup**: "Offline AI (Private, Fast, ~3.4 GB)". Download progress bar with size and speed indicators.
- **Screen 8 — Language Resources**: Single smooth step-progress indicator (Vocabulary → Grammar → Speech → Ready).
- **Screen 9 — Success**: "Everything is ready. Today's learning session takes about 12 minutes." Single CTA `[ Start Learning ]`.

---

## 5. Domain Models & Database Persistence (`packages/learner` & `packages/storage`)

Extends SQLite `settings`, `users`, `profiles`, and `language_profiles` tables with:
- `onboarding_completed`: `'true'`
- `installed_ai_model`: `'recommended_offline_v1'`
- `installed_language_pack`: `'de_A1_v1'`

---

## 6. Accessibility, Motion & Telemetry

- **Semantics**: Full screen reader announcements on step change (`SemanticsService.announce`).
- **Motion**: `280ms cubic-bezier(0.2, 0.8, 0.2, 1)` directional slide transitions between onboarding screens.
- **Telemetry**: Per-step completion time logged to SQLite event store.

---

## 7. Definition of Done

1. Capability Registry initialized and controlling offline AI & Sync capabilities.
2. Complete 10-step FTUE flow fully implemented with zero mock data.
3. User selections (Identity, Sync, Native/Target Language, Goal, Starting Point, Resource Provisioning) stored directly in SQLite.
4. App shutdown & relaunch immediately bypasses FTUE and loads personalized Today screen with identical state.
5. 100% automated test pass rate for fresh install, FTUE wizard steps, and state restoration.
