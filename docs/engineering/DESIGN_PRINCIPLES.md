# DiLang Design Principles & Visual System

## 1. Design Vision

DiLang's interface is built to evoke focus, confidence, and cognitive clarity. It pairs dark-mode glassmorphism with high-contrast typography, harmonious dynamic accent colors, and tactile micro-animations to create a premium native application experience across Desktop and Mobile.

---

## 2. Color System & Design Tokens

DiLang strictly avoids raw default colors (plain red, plain blue). All color tokens are defined using HSL dynamic palettes.

```css
:root {
  /* Surface & Background Tokens */
  --bg-dark-base: hsl(222, 24%, 8%);
  --bg-dark-surface: hsl(220, 20%, 12%);
  --bg-glass-card: hsla(220, 18%, 16%, 0.65);
  --border-glass: hsla(220, 15%, 30%, 0.35);

  /* Primary & Accent Palettes */
  --accent-primary: hsl(160, 84%, 39%);    /* Emerald Green */
  --accent-secondary: hsl(265, 89%, 66%);  /* Electric Violet */
  --accent-warning: hsl(38, 92%, 50%);     /* Amber Golden */
  --accent-error: hsl(352, 83%, 62%);     /* Crimson Coral */

  /* Text & Contrast Tokens */
  --text-high-contrast: hsl(210, 40%, 98%);
  --text-medium-contrast: hsl(215, 20%, 75%);
  --text-muted: hsl(215, 15%, 50%);
}
```

---

## 3. Glassmorphism & Layout System

- **Glass Containers**: Backdrop blur of $16\text{px}$ with a 1px border gradient (`hsla(0, 0%, 100%, 0.12)` to `hsla(0, 0%, 100%, 0.03)`).
- **Responsive Layout Grids**:
  - **Mobile ($<600\text{px}$)**: Single column with bottom navigation bar and floating voice control drawer.
  - **Tablet ($600-1024\text{px}$)**: Dual-pane master-detail view for roleplay dialogue + real-time diagnostic side-sheet.
  - **Desktop ($>1024\text{px}$)**: Three-column layout: Navigation Rail | Main Practice Canvas | Epistemic Memory & FSRS Graph Inspector.

---

## 4. Micro-Animations & Interaction Haptics

1. **State Transitions**: All UI state changes must utilize implicit animations (`AnimatedContainer`, `AnimatedSwitcher`) with a duration of $200\text{ms}$ using `Cubic(0.2, 0.0, 0.0, 1.0)`.
2. **Audio Waveforms**: Live mic input must drive smooth 60 FPS real-time vector canvas waveforms linked to energy decibels.
3. **Card Swipes**: Flashcard reviews trigger spring-physics dynamics (stiffness: 300, damping: 20) with immediate haptic feedback on rating selection.
