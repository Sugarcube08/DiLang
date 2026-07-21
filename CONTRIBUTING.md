# Contributing to DiLang

Thank you for your interest in contributing to **DiLang**!

## 1. Non-Negotiable Architectural Rules
Before submitting code, ensure you have read:
- [03_RULES.md](docs/03_RULES.md)
- [13_ENGINEERING_GUIDELINES.md](docs/13_ENGINEERING_GUIDELINES.md)

### Key Mandates:
1. **Contract-First**: Every public interface or event must be defined in `/docs` prior to PR review.
2. **Pure Dart Core**: Packages in `packages/core`, `language`, `learner`, `memory` must NOT import Flutter SDK or UI elements.
3. **LLM Boundary**: LLMs never directly update database state or learner mastery scores.

---

## 2. Pull Request Submission Checklist
- [ ] Code follows Conventional Commit message rules (`feat:`, `fix:`, `docs:`).
- [ ] All unit tests pass locally (`melos run test`).
- [ ] Static analysis produces zero warnings (`melos run analyze`).
- [ ] Relevant documentation in `/docs` updated if introducing new contracts.
- [ ] Contribution submitted under Apache License 2.0 terms.
