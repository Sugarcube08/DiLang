# DiLang — Personal Language OS

**Version**: v2.1-FROZEN  
**License**: Open Source  

DiLang is an offline-first, local-first, privacy-first personal **Language Operating System (OS)** designed for interactive AI conversation practice, cognitive skill modeling, and FSRS-4.5 spaced repetition memory tracking.

---

## Frozen Architecture Overview

DiLang is built as a single, clean, strictly layered Flutter application:

- **`lib/app/`**: Application-level bootstrap, runtime kernel, routing, and Riverpod DI.
- **`lib/core/`**: Core constants, event bus, errors, common models, and utilities.
- **`lib/modules/`**: Uniform feature modules (`onboarding`, `identity`, `dashboard`, `conversation`, `learning`, `knowledge_graph`, `speech`, `diagnostics`, `settings`).
- **`lib/infrastructure/`**: Hardware & platform infrastructure (`sqlite`, `ai`, `secure_storage`, `filesystem`, `preferences`, `logging`, `platform`).
- **`lib/shared/`**: Design system tokens, reusable widgets, theme, components, extensions, and helpers.

---

## The Runtime Rule

```text
Widget ──► Controller ──► Service ──► Repository ──► Infrastructure ──► SQLite / AI / Filesystem
```

- **Widgets** never touch SQLite, AI providers, Filesystem, or Platform APIs directly.
- **Services** do not render UI.
- **Repositories** contain zero business logic.
- **Infrastructure** never imports feature modules.

---

## Specifications

Detailed architectural specifications are located in [`docs/`](docs/):

- [Vision & Core Philosophy](docs/Vision.md)
- [Product Requirements](docs/ProductRequirements.md)
- [System Architecture](docs/Architecture.md)
- [Application Runtime](docs/ApplicationRuntime.md)
- [Domain Data Model](docs/DataModel.md)
- [AI Infrastructure](docs/AiRuntime.md)
- [Speech Runtime](docs/SpeechRuntime.md)
- [Learning Engine](docs/LearningEngine.md)
- [Design System](docs/DesignSystem.md)
- [Development Guide](docs/DevelopmentGuide.md)
- [Product Roadmap](docs/Roadmap.md)
- [Contributing Guidelines](docs/Contributing.md)
