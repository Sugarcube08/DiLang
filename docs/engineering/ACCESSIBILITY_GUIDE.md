# DiLang Accessibility Guide (a11y)

## 1. Compliance Standard

DiLang complies fully with the **WCAG 2.1 Level AA** accessibility standards across Linux, macOS, Windows, Android, and iOS platform builds.

---

## 2. Core Requirements

### 2.1 Screen Reader Integration (Flutter Semantics)
- All interactive controls (buttons, rating chips, audio sliders, navigation links) MUST specify explicit `Semantics` labels and hints.
- Dynamic transcript updates during roleplay dialogue auto-announce via `SemanticsService.announce()` calls.

### 2.2 Visual Contrast & Font Scaling
- **Contrast Ratios**: Body text against surface background maintains minimum contrast ratio of $4.5:1$ ($7.0:1$ for high-contrast mode).
- **Dynamic Text Scaling**: Supporting system text scale factors up to $200\%$ without layout clipping or text truncation.

### 2.3 Focus Management & Screen Navigation
- Full keyboard traversal support (`Tab`, `Shift+Tab`, `Arrow` keys). Focus rings highlighted using high-contrast emerald outline (`hsl(160, 84%, 39%)`).
