# DiLang Design System Specification (v1.0 Frozen)

> **GOVERNANCE RULE**: Design System v1.0 is officially **FROZEN**. No new UI component may be introduced unless it can be composed directly from existing design tokens and the atomic component library (`DiLangButton`, `DiLangCard`, `DiLangInput`, `DiLangProgress`, `GlassContainer`).

---

## 1. Design Tokens Reference

### Spacing System (8-Point)
`4px, 8px, 12px, 16px, 20px, 24px, 32px, 40px, 48px, 64px`

### Icon Abstraction (`DiIcons`)
- `DiIcons.settings`, `DiIcons.mic`, `DiIcons.brain`, `DiIcons.analytics`, `DiIcons.learning`, `DiIcons.play`, `DiIcons.tune`, `DiIcons.themeToggle`, `DiIcons.spark`, `DiIcons.check`, `DiIcons.warning`, `DiIcons.refresh`.
- **Constraint**: UI code must NEVER reference `Icons.*` directly.

### Asset Registry (`AppAssets`)
- Strongly typed getters in `AppAssets.logoIcon`, `AppAssets.logoFull`, `AppAssets.logoMono`, `AppAssets.flags*`.

### Semantic Color Access (`context.colors`)
- Raw color instantiations (`Color(0xFF...)`) are PROHIBITED outside `app_colors.dart`.
- Access semantic color tokens via `context.colors`:
  - `primary`, `secondary`, `accent`, `surface`, `background`, `container`, `outline`, `success`, `warning`, `error`, `info`
  - Domain semantic tokens: `conversationUser`, `conversationAI`, `vocabularyKnown`, `vocabularyWeak`, `grammarWeak`, `grammarStrong`.

### Glassmorphism Rules
- **Blur Radius**: `20px` to `24px`
- **Fill Opacity**: `55%` (`rgba(24, 28, 35, 0.55)` in dark theme, `rgba(255, 255, 255, 0.55)` in light theme)
- **Border**: `1px` stroke with `12%` white opacity (`rgba(255, 255, 255, 0.12)`)
- **Usage**: Restricted to Cards, Floating Panels, Bottom Player, AI Assistant, and Dialogs. Never applied to full pages.

### Motion & Micro-Animations
- **Durations**: `150ms` (hover/tap), `250ms` (transitions), `350ms` (modals/drawers)
- **Easing Curve**: `easeOutCubic` (`Cubic(0.215, 0.61, 0.355, 1.0)`)
