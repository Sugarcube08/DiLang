# DiLang Scrum Definitions: DoR, DoD & Triage SLAs

## 1. Definition of Ready (DoR)

A Product Backlog Item (PBI) is considered **Ready** for sprint entry if and only if:
1. **User Story Structure**: Expressed as "As a [role], I want [capability] so that [business value]".
2. **Clear Acceptance Criteria**: Specific, testable conditions formatted as Given/When/Then scenarios.
3. **Architectural Alignment**: Explicitly designates target Rust crate or Flutter layer without architectural boundary violations.
4. **Estimation**: Estimated in Story Points by the engineering team (Fibonacci sequence: 1, 2, 3, 5, 8, 13).

---

## 2. Definition of Done (DoD)

A Product Backlog Item is considered **Done** if and only if:
1. **Code Implementation**: Rust crate code passes `cargo clippy -- -D warnings`; Flutter code passes `flutter analyze`.
2. **Automated Testing**: Unit tests added/updated with $\ge 85\%$ Rust coverage and $\ge 80\%$ Flutter widget coverage.
3. **Cross-Platform Verification**: Verified on at least two native targets (e.g. Linux Desktop and Android Mobile).
4. **Documentation Update**: Applicable specs in `docs/engines/`, `docs/engineering/`, or `docs/adr/` updated.
5. **No Regressions**: Benchmark latency tests confirm no degradation of STT/LLM SLAs.

---

## 3. Bug Severity & SLA Triage Matrix

| Severity Level | Response SLA | Resolution SLA | Example Scenario |
| :--- | :--- | :--- | :--- |
| **P0 - Critical** | $< 2\text{ hours}$ | $< 24\text{ hours}$ | Data loss in SQLite, FSRS stability calculation crash, cold start app crash |
| **P1 - Major** | $< 8\text{ hours}$ | $< 72\text{ hours}$ | Speech pipeline stall, audio playback artifacting, incorrect CEFR tag classification |
| **P2 - Minor** | $< 24\text{ hours}$ | $< 1\text{ sprint}$ | Minor UI layout misalignment, missing localization string |
