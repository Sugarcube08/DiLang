# Contributing to DiLang 🚀

Thank you for your interest in contributing to **DiLang**! We are building a privacy-first, local-first AI-native language learning ecosystem. By participating, you help establish software freedom and accessible AI education for learners globally.

---

## 📋 Table of Contents

1. [Architectural & Governance Principles](#1-architectural--governance-principles)
2. [Developer Certificate of Origin (DCO)](#2-developer-certificate-of-origin-dco)
3. [Development Environment Setup](#3-development-environment-setup)
4. [Git Workflow & Commit Guidelines](#4-git-workflow--commit-guidelines)
5. [Pull Request Rules & Submission](#5-pull-request-rules--submission)
6. [Engineering & Coding Standards](#6-engineering--coding-standards)
   - [Flutter & Dart Guidelines](#flutter--dart-guidelines)
   - [Rust Guidelines](#rust-guidelines)
   - [Cross-Language (FFI) Guidelines](#cross-language-ffi-guidelines)
7. [Testing & Quality Assurance](#7-testing--quality-assurance)

---

## 1. Architectural & Governance Principles

Every contribution must align with DiLang's core tenets:

- 🔒 **Privacy First**: Zero telemetry, zero analytics tracking, zero secret remote calls.
- ⚡ **Local First & Offline First**: Core capabilities (LLM dialogue, STT transcription, TTS synthesis, spaced repetition) must run on-device without requiring an internet connection.
- 🚀 **Performance & Memory Efficiency**: Model inference and audio processing must remain within reasonable memory footprints (< 2.5 GB RAM peak on mobile) and prevent thermal throttling.

---

## 2. Developer Certificate of Origin (DCO)

To ensure clear open-source IP provenance, DiLang uses the **Developer Certificate of Origin (DCO)** version 1.1. All commits sent to this repository must include a `Signed-off-by` header line matching your Git commit author name and email address.

```text
Signed-off-by: Jane Doe <jane.doe@example.com>
```

You can automatically sign your commits by using the `-s` flag:
```bash
git commit -s -m "feat(inference): integrate gemma 3 1b quantized backend"
```

By adding a DCO sign-off, you certify the text defined at [DeveloperCertificate.org](https://developercertificate.org/).

---

## 3. Development Environment Setup

Ensure you have installed the required toolchains:

1. **Flutter SDK**: `>= 3.22.0` (Stable channel)
2. **Rust Toolchain**: `>= 1.80.0` (installed via `rustup`)
3. **flutter_rust_bridge_codegen**: `>= 2.0.0`
   ```bash
   cargo install 'flutter_rust_bridge_codegen@^2.0.0'
   ```
4. **Native Build Dependencies**:
   - macOS: Xcode Command Line Tools, CMake
   - Linux: `build-essential`, `pkg-config`, `libssl-dev`, `clang`, `cmake`
   - Windows: Visual Studio 2022 C++ Build Tools, CMake

---

## 4. Git Workflow & Commit Guidelines

### Branching Strategy

- `main`: Production-ready branch. All merges must pass CI and receive explicit code reviews.
- `feat/<short-description>`: New feature implementations.
- `fix/<short-description>`: Bug fixes and security patches.
- `refactor/<short-description>`: Internal code refactoring without external API changes.
- `docs/<short-description>`: Documentation updates.

### Conventional Commits

Commit messages must adhere to the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```text
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

#### Allowed Types:
- `feat`: New user-facing or internal feature.
- `fix`: Bug fix.
- `docs`: Documentation changes.
- `style`: Formatting, missing semi-colons, no code changes.
- `refactor`: Code restructuring without bug fixes or new features.
- `perf`: Performance optimizations.
- `test`: Adding or correcting tests.
- `ci`: CI configuration changes.
- `chore`: Build process or tooling maintenance.

#### Example:
```text
feat(storage): implement FSRS-4.5 spaced repetition review query

Adds SQLite custom query optimization for calculating retention probabilities 
based on item stability and difficulty parameters.

Signed-off-by: Developer Name <developer@example.com>
```

---

## 5. Pull Request Rules & Submission

1. **Link Issues**: Every PR should reference an existing GitHub Issue or ADR proposal.
2. **Clean Commit History**: Rebase against latest `main` before opening PR. Avoid merge commits in topic branches.
3. **Automated Validation**: CI must pass with 0 warnings before review (`flutter analyze`, `cargo clippy`, unit tests).
4. **Review Process**: At least one core maintainer approval is required for merge.
5. **No Placeholder Code**: Submissions containing TODOs without associated issue numbers or mock dummy data in production paths will be requested for revision.

---

## 6. Engineering & Coding Standards

### Flutter & Dart Guidelines

- **Lint Compliance**: Strictly adhere to rules defined in `analysis_options.yaml` (based on `flutter_lints`).
- **State Management**: Keep UI components decoupled from business logic and FFI state.
- **Null Safety**: Sound null safety is strictly enforced. Never use `!` assertion without defensive guards or documentation.
- **Localization**: UI text must be localized; do not hardcode user-facing strings directly in widget trees.

### Rust Guidelines

- **Zero Warnings**: Code must compile cleanly with `cargo clippy --all-targets --all-features -- -D warnings`.
- **Formatting**: Run `cargo fmt --all` prior to committing.
- **Error Handling**: Use `thiserror` for library error types and avoid `unwrap()` or `expect()` in production paths. Always propagate errors cleanly to the Dart layer.
- **Unsafe Code**: Minimize `unsafe` blocks. Any `unsafe` block MUST be preceded by a `// SAFETY:` comment justifying why memory safety invariants hold.

### Cross-Language (FFI) Guidelines

- Use `flutter_rust_bridge` to auto-generate binding layers.
- Avoid passing raw pointers across the FFI boundary; prefer serialized structs, arrays, or primitive handles.
- Asynchronous tasks in Rust must be dispatched on background thread pools to prevent blocking Flutter's main UI isolate.

---

## 7. Testing & Quality Assurance

Before submitting a PR, verify local checks:

```bash
# 1. Format checks
cargo fmt --all -- --check
dart format --output=none --set-exit-if-changed .

# 2. Linting
cargo clippy --all-targets --all-features -- -D warnings
flutter analyze

# 3. Running Unit & Integration Tests
cargo test --workspace
flutter test
```

Thank you for building the future of local-first AI language learning with DiLang! 🌟
