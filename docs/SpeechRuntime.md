# DiLang — Speech Runtime Specification

**Version**: 2.0-RESET  
**Status**: Authoritative  

---

## 1. Real Hardware Audio Pipeline

Speech recognition and voice synthesis operate using real hardware device interfaces managed under `lib/infrastructure/speech/`:

```text
[Hardware Microphone] ──► [SpeechToTextEngine (STT)] ──► [ConversationRuntime]
                                                                  │
[Hardware Speaker]    ◄── [TextToSpeechEngine (TTS)] ◄────────────┘
```

---

## 2. Component Specifications

1. **Microphone Capture**: Captures 16-bit PCM audio samples directly from OS input drivers.
2. **Speech-to-Text (STT)**: Transcribes incoming audio streams into text strings using on-device Whisper or platform native speech engines.
3. **Text-to-Speech (TTS)**: Synthesizes text strings into audio playback using local Piper voices or platform speech engines.
4. **Voice Visualization**: Translates real-time audio amplitude into visual wave animations via `VoiceVisualizerModel`.

---

## 3. Production Non-Negotiables

- Simulated audio pipelines and fake speech fallbacks are strictly prohibited in production builds.
