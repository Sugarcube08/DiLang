# 42. Master Product & User Journey Specification — DiLang

**Document Version:** 2.1.0  
**Status:** Approved / Source of Truth — Product Engineering

---

## 1. Product Philosophy

DiLang is built around a single adaptive product platform. Flutter applications on Android, iOS, Windows, macOS, Linux, and Web (PWA) act as visual presentation clients consuming frozen platform kernels (`v2.x`).

```
                Platform Kernels (Frozen Core / AI / Storage)
                                    │
                                    v
                       Application Layer (Riverpod DI)
                                    │
                                    v
                     Design System & Product UI Packages
                                    │
                                    v
                    Adaptive Layout Breakpoints (Phone / Tablet / Desktop)
```

---

## 2. Standard Product Navigation Structure

Bottom / Sidebar navigation options:
1. **Home / Dashboard**: Engine recommendations, retention status, and session resume.
2. **Learn**: CEFR Objective DAG, grammar prerequisites, and exercise cards.
3. **Conversation**: Local voice dialogue with real-time waveform visualizers.
4. **Review**: FSRS-4.5 spaced-repetition flashcards and phoneme practice.
5. **Progress**: Competency analytics, retrievability decay curves, and CEFR evidence.
6. **Settings**: Offline AI model manager, local backup, and privacy controls.
