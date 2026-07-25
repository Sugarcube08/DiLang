# DiLang — Definition of Done (DoD)

**Version**: 1.0-DOD  
**Status**: Mandatory Feature Completion Checklist  

---

## Feature Completion Checklist

### Architecture
- [ ] No dependency matrix rule violated (`docs/DependencyMatrix.md`).
- [ ] Feature module boundaries strictly respected (`modules/<feature_name>/`).
- [ ] Extended Runtime Rule respected (`Widget` ➔ `Controller` ➔ `DiLangRuntime` ➔ `Service` ➔ `Repository` ➔ `Infrastructure` ➔ `SQLite/AI`).

### Contracts & Models
- [ ] Interface contracts defined prior to implementation.
- [ ] Domain models fully documented and immutable (`Equatable`).
- [ ] Abstract repository contracts implemented under `repositories/` and `infrastructure/`.

### Testing
- [ ] Unit tests written and passing for all math, services, and state logic (`test/unit/`).
- [ ] Widget tests written and passing for UI components (`test/widget/`).
- [ ] Integration tests written and passing for SQLite persistence (`test/integration/`).

### Code Quality
- [ ] `flutter analyze .` passes with 0 errors, 0 warnings, 0 hints.
- [ ] `dart format .` executed with zero formatting diffs.
- [ ] No temporary `TODO`s, `FIXME`s, or placeholder hacks in production code.
- [ ] No unused files, classes, or dead code.

### Documentation
- [ ] Public APIs and class signatures documented.
- [ ] System architecture remains unaffected and compliant with `Constitution.md`.

### Performance
- [ ] No unnecessary widget rebuilds; state subscriptions scoped using Riverpod `ref.watch` / `select`.
- [ ] No blocking I/O or heavy synchronous calculations executed on the main UI thread.

### Accessibility & Responsiveness
- [ ] Keyboard focus navigation supported.
- [ ] Semantics and screen reader labels provided for interactive widgets.
- [ ] Layout scales fluidly across Desktop (`>1024px`), Tablet (`600px-1024px`), and Mobile (`<600px`).

### Privacy & Security
- [ ] Zero telemetry, zero analytics tracking, zero privacy violations.
- [ ] No unexpected external network requests.
- [ ] Sensitive user keys stored via `SecureStorage` interface.
