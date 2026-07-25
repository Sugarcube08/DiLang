# DiLang — Personal Language OS

**Version**: v2.1-FROZEN  
**License**: Open Source  

DiLang is an offline-first, local-first, privacy-first personal **Language Operating System (OS)** designed for interactive AI conversation practice, cognitive skill modeling, and FSRS-4.5 spaced repetition memory tracking.

---

## Frozen Architecture & Engineering Lifecycle

DiLang is built as a single, clean, strictly layered Flutter application:

```text
Widget ──► Controller ──► DiLangRuntime ──► Service ──► Repository ──► Infrastructure ──► SQLite / AI
```

### Feature Engineering Workflow
```text
Select Feature ──► Contract ──► Models ──► Unit Tests ──► Service ──► Repository ──► DiLangRuntime ──► UI ──► Integration Tests ──► DoD Check
```

---

## Documentation

System specifications and engineering standards are located in [`docs/`](docs/):

- [Constitution & Non-Negotiables](docs/Constitution.md)
- [Definition of Done (DoD)](docs/DefinitionOfDone.md)
- [Dependency Import Matrix](docs/DependencyMatrix.md)
- [System Architecture](docs/Architecture.md)
- [Application Runtime](docs/ApplicationRuntime.md)
- [Domain Data Model](docs/DataModel.md)
- [AI Infrastructure](docs/AiRuntime.md)
- [Speech Runtime](docs/SpeechRuntime.md)
- [Learning Engine & FSRS Math](docs/LearningEngine.md)
- [Design System](docs/DesignSystem.md)
- [Development Guide](docs/DevelopmentGuide.md)
- [Product Roadmap](docs/Roadmap.md)
- [Contributing Guidelines](docs/Contributing.md)
