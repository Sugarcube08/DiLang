# DiLang Product Requirements Document (PRD)

## 1. Executive Summary
DiLang is an open-source, privacy-first, local-first, AI-native language learning application. It operates entirely on-device without cloud server dependencies for core conversational education, grammar evaluation, vocabulary drill, or spaced repetition scheduling.

## 2. Core Functional Requirements

### 2.1 Conversational AI Roleplay Engine
- **Req-1.1**: Must run on-device quantized Gemma 3 1B LLM via `llama.cpp`.
- **Req-1.2**: Latency for first-token response must be < 800ms on modern desktop/mobile hardware.
- **Req-1.3**: Provides real-time grammatical corrections and vocabulary hints during conversation.

### 2.2 Voice Input & Output Pipeline
- **Req-2.1**: Speech-to-Text (STT) executed locally via `Whisper.cpp` (tiny/base models).
- **Req-2.2**: Text-to-Speech (TTS) synthesized locally via `Piper` neural voices.
- **Req-2.3**: Zero streaming of audio data over public internet.

### 2.3 Memory & Spaced Repetition (FSRS v4)
- **Req-3.1**: Implements FSRS v4 algorithm natively in Rust core.
- **Req-3.2**: Tracks retrievability ($R$), stability ($S$), and difficulty ($D$) for every learned word and phrase.
- **Req-3.3**: Supports custom deck imports (Anki `.apkg` format).

### 2.4 Privacy & Local Storage
- **Req-4.1**: SQLite database encrypted via SQLCipher AES-256.
- **Req-4.2**: Vector similarity search integrated via `sqlite-vec` (384-dim embeddings).
- **Req-4.3**: Zero telemetry, zero analytics trackers, zero external phone-home calls.
