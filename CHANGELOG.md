# Changelog — DiLang Monorepo

All notable changes to the DiLang project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0-phase.2] - 2026-07-22

### Added
- **Repository Governance & CI/CD**: Established root workspace configuration (`pubspec.yaml`, `melos.yaml`, `analysis_options.yaml`, `.editorconfig`, `.gitignore`, `.gitattributes`, `.fvmrc`).
- **Human Engineering Guidelines**: Created [13_ENGINEERING_GUIDELINES.md](docs/13_ENGINEERING_GUIDELINES.md).
- **Core Domain Packages**:
  - `packages/core`: Pure Dart Core Kernel (Kernel orchestrator, SystemBootstrapper, Async EventBus, CapabilityRegistry, PluginManager, PlatformLogger, Error Taxonomy).
  - `packages/language`: Language Intelligence Domain (Phonetics, Vocabulary, Grammar, Phrases, CEFR level models).
  - `packages/learner`: Learner Knowledge Graph & Node State tracking.
  - `packages/memory`: Deterministic Human Memory Engine with mathematical FSRS-4.5 scheduler implementation.
- **Documentation Suite**: Complete 13 contract-first specification documents in `/docs/`.
