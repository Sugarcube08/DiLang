# Changelog 📜

All notable changes to the **DiLang** project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Feature tracking for Phase 1 architecture implementation.

---

## [0.1.0-alpha] - 2026-07-26

### Added
- Initialized core repository governance foundation.
- Added comprehensive project documentation:
  - `README.md`: High-level architecture, technology stack, and repo navigation guide.
  - `LICENSE`: Dual-licensing model (AGPLv3 copyleft + Commercial licensing preamble and full text).
  - `CONTRIBUTING.md`: DCO sign-off policy, Git conventional commit workflow, Flutter & Rust coding guidelines.
  - `CODE_OF_CONDUCT.md`: Contributor Covenant 2.1 adapted for DiLang.
  - `SECURITY.md`: Offline threat model, vulnerability disclosure policy, local storage encryption guidelines.
  - `ROADMAP.md`: Multi-year strategic roadmap spanning Phases 1 to 5.
  - `RELEASE_PROCESS.md`: Cross-platform build pipeline, RC validation, and artifact signing procedures.
  - `VERSIONING.md`: Semantic versioning specifications for Rust crates, Flutter app, and Language Packs schema.
- Added GitHub repository automation templates:
  - Pull Request template (`.github/PULL_REQUEST_TEMPLATE.md`).
  - Issue templates (`bug_report.md`, `feature_request.md`, `adr_proposal.md`).
  - GitHub Actions CI workflow (`.github/workflows/ci.yml`) covering Rust (`cargo clippy`, `cargo test`) and Flutter (`flutter analyze`, `flutter test`).

---

[Unreleased]: https://github.com/dilang-ai/dilang/compare/v0.1.0-alpha...HEAD
[0.1.0-alpha]: https://github.com/dilang-ai/dilang/releases/tag/v0.1.0-alpha
