# 13. Human Engineering Guidelines & Repository Governance — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Engineering Practices

---

## 1. Scope & Purpose

While `03_RULES.md` defines system architecture constraints and AI boundary rules, this document governs **human engineering practices** for all contributors, maintainers, and team members working on the DiLang repository.

---

## 2. Git Branching & Workflow

### 2.1 Branch Naming Conventions
All development occurs on short-lived feature or fix branches created off `main`:

- `feat/<package_name>/<short_description>` (e.g., `feat/memory/fsrs-decay-optimization`)
- `fix/<package_name>/<short_description>` (e.g., `fix/core/event-bus-subscription-leak`)
- `docs/<short_description>` (e.g., `docs/add-engineering-guidelines`)
- `refactor/<package_name>/<short_description>`

### 2.2 Commit Message Format (Conventional Commits v1.0.0)
Every commit message must strictly adhere to Conventional Commits format:

```text
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

#### Allowed Types:
- `feat`: A new user-facing or platform capability.
- `fix`: A bug fix or error correction.
- `docs`: Documentation changes only.
- `style`: Formatting, missing semi-colons, no code logic changes.
- `refactor`: Code refactoring without feature addition or bug fix.
- `test`: Adding or updating unit/integration tests.
- `chore`: Build script, configuration, or workspace tool updates.

---

## 3. Package Boundaries & Dependency Discipline

1. **Inward Dependency Flow Only**: `UI -> Features -> Application -> Domain -> Core -> Infrastructure -> Native`. No circular dependencies are allowed between packages under `packages/`.
2. **Independent Package Definition**: Every package inside `packages/` must contain its own `pubspec.yaml`, `analysis_options.yaml`, `README.md`, `CHANGELOG.md`, `LICENSE`, and `test/` directory.
3. **Pure Dart Isolation**: Domain packages (`core`, `language`, `learner`, `memory`) must remain 100% pure Dart, free of Flutter SDK or platform UI imports.

---

## 4. Code Review & Pull Request Gates

No code may be merged into `main` unless:
1. **CI Pipeline Pass**: Static analysis (`dart analyze`), unit tests (`dart test`), and license compliance checks pass with zero warnings.
2. **Contract Update Approval**: If a PR introduces or modifies a domain interface, Protobuf schema, or event, the corresponding contract document in `/docs` must be updated within the same PR.
3. **Reviewer Approvals**: Minimum 1 maintainer approval required via GitHub Codeowners.

---

## 5. Deprecation & Backward Compatibility Policy

- **Contract Versioning**: Every event schema and API contract carries a major/minor version number.
- **Deprecation Grace Period**: Interfaces marked `@Deprecated` must remain functional for at least one major release cycle before removal.
- **Wire Compatibility**: Protobuf schema field numbers must never be reused or reassigned.
