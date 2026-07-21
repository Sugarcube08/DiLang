# 05. UI/UX & System Design Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved Design System  
**Framework:** Flutter (Custom Theme & Widgets)

---

## 1. Design Aesthetics & Visual Philosophy

DiLang is engineered with a **premium, immersive, dark-first visual identity**. The interface reflects an intelligent, state-of-the-art learning environment rather than a gamified toy app.

- **Glassmorphism & Depth**: Subtle multi-layered background blurs (`BackdropFilter`), semi-transparent surfaces (`rgba(255, 255, 255, 0.04)`), crisp 1px borders with subtle gradients.
- **Dynamic HSL Color Tokens**: Tailored color scales that adjust harmoniously across themes without harsh primary colors.
- **Fluid Micro-Animations**: Smooth curves (`Cubic(0.2, 0.0, 0.0, 1.0)`) for state transitions, audio waveforms, and graph node expansions.
- **Responsive Layout Architecture**: Native desktop sidebars and multi-pane views on desktop/tablet, adaptive bottom navigation and touch gestures on mobile.

---

## 2. Dynamic HSL Color Palette

```
  Primary Indigo        Accent Cyan          Success Emerald
  hsl(245, 82%, 67%)    hsl(185, 96%, 72%)   hsl(155, 78%, 48%)
  
  Warning Amber         Error Crimson        Background Dark
  hsl(38, 92%, 56%)     hsl(350, 89%, 60%)   hsl(222, 47%, 9%)
```

### 2.1 Color Tokens Specification

```dart
abstract class DiLangColors {
  // Base Surface Colors (Dark Mode Default)
  static const Color background = HSLColor.fromAHSL(1.0, 222, 0.47, 0.09).toColor();
  static const Color surface = HSLColor.fromAHSL(1.0, 220, 0.35, 0.13).toColor();
  static const Color surfaceElevated = HSLColor.fromAHSL(1.0, 220, 0.30, 0.18).toColor();
  static const Color surfaceBorder = Color(0x1F2C3A4E);

  // Accent & Brand Colors
  static const Color primary = HSLColor.fromAHSL(1.0, 245, 0.82, 0.67).toColor();
  static const Color primaryGlow = Color(0x40635BFF);
  static const Color secondary = HSLColor.fromAHSL(1.0, 185, 0.96, 0.72).toColor();
  static const Color accentSpark = HSLColor.fromAHSL(1.0, 280, 0.85, 0.68).toColor();

  // Functional Learning Status Colors
  static const Color masteryNew = HSLColor.fromAHSL(1.0, 210, 0.80, 0.60).toColor();
  static const Color masteryLearning = HSLColor.fromAHSL(1.0, 38, 0.92, 0.56).toColor();
  static const Color masteryMastered = HSLColor.fromAHSL(1.0, 155, 0.78, 0.48).toColor();
  static const Color masteryReview = HSLColor.fromAHSL(1.0, 350, 0.89, 0.60).toColor();

  // Typography Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
}
```

---

## 3. Typography Hierarchy

Primary Font Family: `Outfit` (Headings, Metrics, Graph Labels)  
Secondary Font Family: `Inter` (Body Text, Explanations, Translations)  
Monospace Font Family: `JetBrains Mono` (Phonetic IPA symbols, event logs, code snippets)

```text
Display Large    36pt / LineHeight 1.15 / Weight 700 / Outfit
Heading 1        28pt / LineHeight 1.20 / Weight 600 / Outfit
Heading 2        22pt / LineHeight 1.25 / Weight 600 / Outfit
Subtitle 1       18pt / LineHeight 1.30 / Weight 500 / Inter
Body Regular     15pt / LineHeight 1.50 / Weight 400 / Inter
Phonetic IPA     14pt / LineHeight 1.40 / Weight 500 / JetBrains Mono
Caption / Meta   12pt / LineHeight 1.40 / Weight 400 / Inter
```

---

## 4. Custom Components & Interactive Widgets

1. **Interactive Audio Waveform**: Displays real-time audio input from microphone during speech exercises with STT phoneme alignment overlays.
2. **Knowledge Graph Node Map**: Canvas-rendered dynamic graph visualizing nodes (words/rules) linked by semantic and difficulty edges with color-coded mastery metrics.
3. **SRS Flashcard Deck**: Gesture-enabled card flipper with micro-vibrations, audio pronunciation triggers, and standard FSRS response buttons (`Again`, `Hard`, `Good`, `Easy`).
4. **Dialogue Thread View**: Split message view highlighting detected grammatical errors inline with tap-to-explain popups powered by local LLM explanations.
