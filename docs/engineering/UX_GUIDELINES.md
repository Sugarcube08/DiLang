# DiLang User Experience (UX) Guidelines

## 1. Ergonomic Principles

1. **Immediate Feedback Loop**: Spoken audio input must present active waveform visual feedback within $50\text{ms}$ of speech detection to eliminate perceived latency.
2. **Non-Intrusive Error Coaching**: Diagnostic grammar and vocabulary feedback should never block dialogue flow. Corrections are rendered as subtleInline annotations or expandable side-drawers.
3. **Hands-Free Conversational Mode**: Full continuous voice interaction (Voice Activity Detection $\rightarrow$ Whisper STT $\rightarrow$ Gemma 3 LLM $\rightarrow$ Piper TTS) allows users to practice without manual screen tapping.

---

## 2. Dynamic Input States

```
┌─────────────────────────────────────────────────────────────┐
│                    Voice Input Component                    │
└──────┬──────────────────────┬───────────────────────┬───────┘
       │                      │                       │
       ▼                      ▼                       ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────────┐
│ IDLE / READY │ ───► │ LISTENING... │ ───► │ PROCESSING...    │
│ (Green Ring) │      │ (Live Wave)  │      │ (Pulse Spinner)  │
└──────────────┘      └──────────────┘      └──────────────────┘
```

---

## 3. Keyboard & Desktop Shortcuts

| Action | macOS Shortcut | Windows / Linux Shortcut |
| :--- | :--- | :--- |
| **Toggle Voice Mic** | `Cmd + Space` | `Ctrl + Space` |
| **Grade Card (Again)** | `1` | `1` |
| **Grade Card (Hard)** | `2` | `2` |
| **Grade Card (Good)** | `3` | `3` |
| **Grade Card (Easy)** | `4` | `4` |
| **Show Translation** | `T` | `T` |
