# DiLang Development Rules & Coding Standards

## 1. Rust Code Standards (`crates/`)

### 1.1 Code Formatting & Linting
- All Rust code must pass `cargo fmt --check` and `cargo clippy --all-targets -- -D warnings`.
- Forbidden: `#[allow(unused)]`, `panic!`, `unwrap()`, or `expect()` in production paths. All errors must be explicitly typed using `thiserror` (for library code) or `anyhow` (for binary execution boundaries).

### 1.2 Memory & Safety
- `unsafe` blocks are strictly prohibited unless interfacing with native third-party C++ libraries (`llama.cpp`, `whisper.cpp`). Any `unsafe` block must include a mandatory `// SAFETY:` explanatory comment detailing invariants.

```rust
// GOOD PRACTICE
#[derive(Debug, thiserror::Error)]
pub enum FsrsEngineError {
    #[error("Invalid stability parameter: {0}")]
    InvalidStability(f64),
    #[error("Database persistence error: {0}")]
    Storage(#[from] sqlx::Error),
}
```

---

## 2. Dart & Flutter Standards (`apps/dilang_flutter/`)

### 2.1 State Management (Riverpod)
- Use `NotifierProvider` or `AsyncNotifierProvider` for state mutation. Direct global mutable variables are forbidden.
- Models must be immutable using `@freezed` or `meta` immutable annotations.

### 2.2 Strict Boundary Scoping
- Flutter views MUST NOT import SQLite, `sqlx`, or call native file paths directly. All data access occurs via generated FRB v2 Dart interfaces.

```dart
// GOOD PRACTICE
class ConversationController extends AsyncNotifier<ConversationState> {
  @override
  Future<ConversationState> build() async {
    // Call Rust FRB bridge API
    final initialSession = await RustLib.instance.api.initSession(scenarioId: 'bakery_a2');
    return ConversationState(session: initialSession);
  }
}
```

---

## 3. Git Workflow & Commit Rules

- **Branch Naming**: `feat/description`, `fix/description`, `refactor/description`.
- **Commit Format**: Conventional Commits standard:
  - `feat(fsrs): add v4 weight optimizer Rust module`
  - `fix(grammar): handle empty user speech token payload`
  - `docs(adr): update ADR-0002 FRB binding specs`
