# DiLang — Contributing Guidelines

**Version**: 2.0-RESET  
**Status**: Authoritative  

---

## 1. Code Standards & Architectural Rules

1. **No Layer Violations**: Modules must not import other modules directly. Use `EventBus` or `DiLangRuntime`.
2. **No Direct Database Access in UI**: Widgets read state from `DiLangRuntime` and must never execute raw SQL or call repositories directly.
3. **Strict Linting**: Code must pass `flutter analyze .` with zero errors or warnings.
4. **Testing Obligation**: New feature additions must include unit or widget tests under `test/`.
