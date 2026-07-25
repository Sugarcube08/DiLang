# DiLang Architecture Constitution

**Version**: 1.0-CONSTITUTIONAL  
**Status**: Highest Engineering Policy (Non-Negotiable)  

---

## 1. Fundamental Principles

1. **One Application**: DiLang is structured as a single, unified Flutter application. Monorepos, microservices, and fragmented package splits are strictly prohibited.
2. **Offline-First by Default**: DiLang operates completely without internet connectivity. Cloud features are optional extensions.
3. **Local-First Data Ownership**: All user data, skill graphs, dialogue transcripts, and cognitive models reside on the user's device.
4. **SQLite is the Only Persistent Datastore**: All structured local state must be stored in the embedded SQLite database. No secondary embedded databases (e.g. Hive, Isar, Realm) may be introduced.
5. **No Feature Bypasses the Runtime**: Features MUST interact through `DiLangRuntime`. Controllers request operations from the runtime; the runtime coordinates underlying services and persistence.
6. **Uniform Feature Module Ownership**: Every feature module (`onboarding`, `identity`, `dashboard`, `conversation`, `learning`, `knowledge_graph`, `speech`, `diagnostics`, `settings`) MUST follow the exact same internal directory structure:
   `models/`, `repositories/`, `services/`, `controllers/`, `pages/`, `widgets/`, `dialogs/`, `providers/`.
7. **Decoupled Infrastructure**: Infrastructure components implement abstract interfaces but MUST NEVER import feature modules or presentation code.
8. **No Mock Implementations in Production**: Production code MUST NOT contain mock providers, fake audio pipelines, or fallback data.
9. **Frozen Architecture**: Features adapt to the architecture; the architecture is never modified to accommodate individual feature quirks.

---

## 2. The Extended Runtime Rule

Every call chain in DiLang MUST adhere strictly to the following unidirectional flow:

```text
Widget
  ↓
Controller
  ↓
Runtime (Application Orchestrator)
  ↓
Service (Business Logic)
  ↓
Repository (Data Access Contract)
  ↓
Infrastructure (Platform Drivers)
  ↓
SQLite / AI / Filesystem
```

### Directives:
- **Widgets** NEVER access SQLite, AI Providers, Filesystems, or Platform APIs directly.
- **Controllers** delegate multi-subsystem orchestration to `Runtime` rather than coordinating multiple services directly.
- **Services** perform calculations and business logic; services NEVER render UI.
- **Repositories** access data via Infrastructure; repositories contain ZERO business logic.
- **Infrastructure** implements low-level drivers and NEVER imports feature modules.
