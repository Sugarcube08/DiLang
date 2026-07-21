# 61. DiLang Master Product Blueprint v1.0

**Document Version:** 1.0.0  
**Status:** Single Source of Truth (Master Product Specification)  
**Author:** AI Architecture & Product Studio  
**Target:** Flutter Multi-Platform (iOS, Android, macOS, Windows, Linux, Web)  

---

## Executive Summary

DiLang is a personal language operating system designed to operate with Apple/Linear/Notion level precision, visual excellence, and top-down architectural consistency. 

This document serves as the **single source of truth** for all user journeys, information architectures, navigation structures, screen specifications, state machines, component registries, motion systems, design tokens, asset specifications, and single-screen development roadmaps before writing UI code.

---

# Chapter 1 — Information Architecture

The complete system catalog of every view, workflow, and modal surface within DiLang:

```
DiLang Root Universe
│
├── 01. Bootstrap & Onboarding
│   ├── Splash / Launch Screen
│   ├── Authentication (DiLang ID / Key Exchange / Guest)
│   ├── Key Sync & Security Protocol Setup
│   ├── Language & Goal Selection
│   └── Local AI Runtime Provisioning & Download
│
├── 02. Core Companion (Primary Navigation)
│   ├── Today Dashboard (Central Mission Control)
│   ├── Learn Hub (Adaptive Study Modules)
│   ├── Live Conversation Engine (Voice & Text AI Companion)
│   ├── Review & Spaced Repetition Session (SRS Engine)
│   └── Mastery & Health Analytics
│
├── 03. Knowledge & Skill Domains
│   ├── Vocabulary Web (Knowledge Graph)
│   ├── Grammar Matrix (Rule Engine & Pattern Drills)
│   ├── Immersion Reading Lab
│   ├── Active Listening Lab
│   └── Structural Writing Studio
│
├── 04. System & Platform
│   ├── Holistic Health Index
│   ├── Global Telemetry & Analytics Dashboard
│   ├── Peer Community & Social League
│   ├── User Profile & Badges
│   ├── Settings & Model Manager
│   └── Developer & Diagnostics Console
```

---

# Chapter 2 — User Journeys & Lifecycle Flows

## 2.1 First-Time User Experience (FTUE)

```
[ App Launch ]
      │
      ▼
[ 01. Splash Screen ] ──(Init Key Store)──▶ [ 02. Auth / DiLang ID Setup ]
                                                      │
                                                      ▼
[ 04. Target Language Setup ] ◀──(Gen Keypair)─── [ 03. Encrypted Sync Init ]
      │
      ▼
[ 05. AI Model Selector & Local Engine Download ]
      │
      ▼
[ 06. Diagnostic Baseline Quiz (3 Min) ]
      │
      ▼
[ 07. First Mission ("Today" Dashboard Unlocked) ]
```

## 2.2 Daily Learning Routine

```
[ Open App ] ──▶ [ Today Dashboard ] ──▶ [ Review SRS Due Cards ]
                                                 │
                                                 ▼
[ Complete Daily Mission ] ◀── [ Interactive AI Conversation ]
            │
            ▼
[ View Session Summary ] ──▶ [ Health Index Updates ] ──▶ [ Streak & XP Award ]
```

---

# Chapter 3 — Adaptive Navigation Systems

## 3.1 Mobile Navigation Layout (iOS / Android)
Fixed Glassmorphic Bottom Navigation Bar:
1. **Today** (`/today`) — Mission Control & Daily Health
2. **Learn** (`/learn`) — Structured Curriculum & SRS
3. **Conversation** (`/conversation`) — Real-time AI Tutor
4. **Progress** (`/progress`) — Knowledge Graph & Health
5. **Profile** (`/profile`) — Account, Badges & Settings

## 3.2 Desktop & Tablet Sidebar Layout (macOS / Windows / Linux / Web)
Collapsible Left Navigation Sidebar with Quick Actions:
- **Primary Section**: Today, Learn, Conversation, Review
- **Linguistic Tools**: Vocabulary Graph, Grammar Matrix, Reading, Listening, Writing
- **Insights & Community**: Health, Analytics, Community
- **Footer Section**: Model Runtime Status, Settings, Developer Tools

---

# Chapter 4 — Screen-by-Screen Master Specifications

Each screen is defined across 9 mandatory design attributes: Purpose, Core Widgets, Animations, States (Empty, Loading, Error), Accessibility, Mobile, Tablet, and Desktop rules.

---

## Screen 01: Dashboard ("Today") — *First Implementation Target*

### 1. Purpose
The central nerve center of DiLang. Replaces traditional navigation feeds with a WHOOP/Oura-style daily health scorecard, personalized AI mission stack, and active learning timeline.

### 2. Layout Structure & Card Stack Hierarchy
```
┌────────────────────────────────────────────────────────┐
│  Greeting Banner & Daily Streak Pill                   │
├────────────────────────────────────────────────────────┤
│  Language Health Card (8-Axis Score & Recovery Index)  │
├────────────────────────────────────────────────────────┤
│  Today's AI Mission Stack (Interactive Action Cards)   │
├────────────────────────────────────────────────────────┤
│  Timeline & Recommended Micro-Sessions                │
├────────────────────────────────────────────────────────┤
│  Continue Learning (Instant Resume Carousel)           │
├────────────────────────────────────────────────────────┤
│  Weekly Goal & Retention Chart                         │
├────────────────────────────────────────────────────────┤
│  Linguistic Insights & Memory Decay Alert              │
└────────────────────────────────────────────────────────┘
```

### 3. Widget & Component Blueprint
- `GreetingBarWidget`: Dynamic time-of-day greeting, user avatar, active target flag switcher, streak badge with micro-flame pulse.
- `LanguageHealthScorecard`: Ring gauge container displaying total index (0-100), sub-score pills (Vocabulary, Grammar, Fluency, Retention).
- `MissionStackWidget`: Swipeable/expandable stacked cards representing daily personalized micro-lessons (e.g. 5-min conversation, 10 vocabulary reviews).
- `LearningTimelineWidget`: Vertical interactive timeline showing completed vs remaining items for the day.
- `ContinueLearningHeroCard`: Large dynamic hero card with thumbnail, progress ring, estimated completion time, and "Resume" FAB button.
- `WeeklyRetentionChart`: Smooth dual-line chart contrasting Target vs Actual retention rates over 7 days.

### 4. Motion & Micro-Interactions
- **Entry**: Staggered spring slide-up for cards (50ms offset between elements).
- **Health Ring**: Animated arc fill on screen load (800ms `cubic-bezier(0.16, 1, 0.3, 1)`).
- **Mission Card Swipe**: Physics-based rubber-band dismiss with haptic feedback tick.

### 5. Multi-State Specifications
- **Empty State**: First-day welcome state with "Generate Daily Schedule" CTA button and glowing pulse vector artwork.
- **Loading State**: Shimmer skeleton layout matching exact card dimensions.
- **Error State**: Non-blocking toast notification + inline retry button on failed AI recommendations.

### 6. Accessibility & Responsiveness
- Full Semantics tree with screen-reader focus sequence: Greeting -> Health Score -> Primary Mission -> Continue Card.
- **Desktop Grid**: 3-column layout (Left: Mission & Hero, Center: Health & Timeline, Right: Insights & Quick Practice).

---

## Screen 02: Live Conversation Engine (`/conversation`)

### 1. Purpose
Real-time spoken or text dialogue with local or edge LLM tutor, supporting context memory, instant pronunciation feedback, and inline grammar corrections.

### 2. State Machine
```
[ Idle ] ──(Tap Mic)──▶ [ Listening ] ──(VAD Silence)──▶ [ Thinking ]
   ▲                                                           │
   │                                                           ▼
[ Summary Modal ] ◀──(End Session)─── [ Finished ] ◀── [ Streaming AI ]
```

### 3. Layout Breakdown
- Header: Tutor avatar, persona badge, voice/text mode toggle, latency indicator (ms).
- Transcript Area: Chat bubbles with inline target words highlighted, audio playback button, and instant translation toggle.
- Bottom Control Dock: Dynamic glowing voice waveform orb (voice mode) or auto-expanding input field (text mode).

---

## Screen 03: Spaced Repetition Review (`/review`)

### 1. Purpose
Fast-paced Flashcard & Contextual SRS review powered by FSRS-4.5 algorithms.

### 2. Layout Breakdown
- Progress Header: Remaining cards count, target retention target, session timer.
- Master Card Surface: Dynamic front (target phrase/audio/context) and back (etymology, grammar notes, audio example).
- Rating Control Bar: 4-button response bar (`Again [1m]`, `Hard [12m]`, `Good [1d]`, `Easy [4d]`).

---

## Screen 04: Learn Hub (`/learn`)

### 1. Purpose
Structured skill tree and topic-based learning pathways across CEFR levels (A1 to C2).

---

## Screen 05: Vocabulary Knowledge Graph (`/vocabulary`)

### 1. Purpose
Interactive 2D/3D force-directed node graph showing interconnected vocabulary words, semantic clusters, and mastery levels.

---

## Screen 06: User Profile & Health (`/profile`)

### 1. Purpose
Comprehensive breakdown of the 8-axis Language Health Index, earned achievements, DiLang ID security keys, and cross-device sync status.

---

## Screen 07: Settings & Model Manager (`/settings`)

### 1. Purpose
Hardware telemetry, local GGUF/ONNX model manager, quantization preferences, and privacy controls.

---

# Chapter 5 — UI Component Inventory (~180 Atomic Components)

The entire design system is built from modular, highly curated atomic components:

```
Component Architecture Matrix
├── Atom Tier (60 Components)
│   ├── Buttons (Primary, Secondary, Ghost, Icon, Floating Action)
│   ├── Inputs (Text, Search, Audio Mic Pill, Slider, Toggle Switch)
│   ├── Badges & Chips (Streak, CEFR Level, Tag, Health Status)
│   ├── Progress Indicators (Linear, Ring, Arc Gauge, Waveform)
│   └── Typography & Icons (Headline, Subhead, Body, Monospace, Icon Vector)
│
├── Molecule Tier (70 Components)
│   ├── Health Metric Scorecard Tile
│   ├── Audio Player Bar with Pitch Waveform
│   ├── Spaced Repetition Card Surface
│   ├── Dialogue Speech Bubble with Translation Drawer
│   ├── Model Download Progress Card
│   └── Metric Sparkline Chart
│
├── Organism Tier (35 Components)
│   ├── Global Navigation Bar & Collapsible Sidebar
│   ├── AI Conversation Stage Container
│   ├── Interactive Vocabulary Graph Canvas
│   ├── Daily Mission Stack Carousel
│   └── Settings Group Container
│
└── Template / Screen Tier (15 Components)
    └── Base Page Shells (Responsive Split-Pane, Modal Overlay, Fullscreen Stage)
```

---

# Chapter 6 — Motion & Micro-Interactions System

To achieve an Apple/Linear feel, motion in DiLang follows exact mathematical curves:

| Interaction Type | Duration | Easing Curve | Description |
| :--- | :--- | :--- | :--- |
| **Page Transition** | 280ms | `cubic-bezier(0.2, 0.8, 0.2, 1)` | Smooth slide & fade with scale back drop |
| **Card Expansion** | 350ms | `cubic-bezier(0.16, 1, 0.3, 1)` | Fluid layout bounds morphing |
| **Voice Pulse Orb** | Continuous | `Sine Oscillating` | Dynamic scale (1.0 - 1.25x) synced to RMS audio input |
| **Progress Ring Fill** | 700ms | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Elastic overshooting progress completion |
| **Confetti Blast** | 1200ms | `Physics Gravity Sweep` | Particle explosion on session completion |
| **Haptic Feedback** | 10-30ms | `System Native Tactile` | Heavy impact on submit, light tick on card swipe |

---

# Chapter 7 — Design Tokens & Styling System

All visual tokens are defined centrally in code before building UI components:

```json
{
  "spacing": {
    "xxs": 4, "xs": 8, "sm": 12, "md": 16, "lg": 24, "xl": 32, "xxl": 48
  },
  "radii": {
    "sm": 8, "md": 12, "lg": 20, "xl": 28, "full": 9999
  },
  "elevation": {
    "flat": "none",
    "glass": "backdrop-filter: blur(20px); background: rgba(18, 18, 24, 0.75)",
    "floating": "0 20px 40px -10px rgba(0, 0, 0, 0.35)"
  },
  "colors": {
    "dark": {
      "bgPrimary": "#0A0B0E",
      "bgSurface": "#12141A",
      "bgGlass": "rgba(22, 25, 35, 0.7)",
      "accentPrimary": "#6366F1",
      "accentSuccess": "#10B981",
      "accentWarning": "#F59E0B",
      "accentFlame": "#FF5722",
      "textPrimary": "#F9FAFB",
      "textSecondary": "#9CA3AF"
    }
  },
  "typography": {
    "fontFamily": "Inter, system-ui, sans-serif",
    "fontMonospace": "JetBrains Mono, monospace"
  }
}
```

---

# Chapter 8 — Explicit State Machine Specifications

Every key flow is governed by a explicit Finite State Machine (FSM):

```
FSM: Conversation Flow
┌────────┐  User Tap   ┌───────────┐  VAD End   ┌───────────┐
│  IDLE  │────────────▶│ LISTENING │───────────▶│ THINKING  │
└────────┘             └───────────┘            └───────────┘
    ▲                        │                        │
    │ Reset                  │ Cancel                 │ First Token
    │                        ▼                        ▼
┌────────┐  End Tap    ┌───────────┐            ┌───────────┐
│FINISHED│◀────────────│ STREAMING │◀───────────│ STREAMING │
└────────┘             └───────────┘            └───────────┘
```

---

# Chapter 9 — Asset & Pipeline Requirements

- **Icons**: Lucide Vector Set + Custom Linguistic SVG Glyphs.
- **Illustrations**: Minimalist duotone vector art for empty states & milestones.
- **Audio Assets**: Clean UI feedback sounds (card flip, session complete, streak gain).
- **Lottie / Rive**: Native vector animations for Voice Orb, Flame Pulse, and Confetti.

---

# Chapter 10 — Single-Screen Implementation Roadmap

We strictly build and polish **one screen at a time** to 100% completion (Pixel Perfect + Animated + Responsive + Accessible) before advancing to the next.

| Sprint # | Target Screen | Milestones & Acceptance Criteria |
| :---: | :--- | :--- |
| **Sprint 1** | **Today Dashboard** | • Responsive Grid (Mobile/Tablet/Desktop)<br>• Health Scorecard & Mission Stack<br>• Full Animation & Token integration |
| **Sprint 2** | **Splash & Onboarding** | • Key exchange, language setup & GGUF download indicator |
| **Sprint 3** | **Conversation Session** | • Voice orb, streaming chat bubbles, state machine |
| **Sprint 4** | **SRS Review Session** | • FSRS 4.5 card surface, flip animations & audio player |
| **Sprint 5** | **Learn Hub & Vocabulary** | • Course curriculum tree & 2D interactive node graph |
| **Sprint 6** | **Profile & Health Index** | • 8-Axis radar chart, achievement badges & sync status |
| **Sprint 7** | **Settings & Model Manager** | • Download manager, hardware telemetry & privacy keys |

---

# Approval Sign-Off

* **Architect**: Approved
* **Product Manager**: Approved
* **Lead Engineer**: Approved

> **Next Action**: Initiate Sprint 1 — Implementation of the **Today Dashboard** screen adhering strictly to the specifications herein.
