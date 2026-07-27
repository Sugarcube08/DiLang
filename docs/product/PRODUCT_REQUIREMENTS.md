# DiLang Product Requirements Document (PRD)

## 1. Executive Summary
DiLang is an open-source, privacy-first, local-first, AI-native language learning application. It operates entirely on-device without cloud server dependencies for core conversational education, grammar evaluation, vocabulary drill, or spaced repetition scheduling.

## 2. Core Functional Requirements

### 2.1 Conversational AI Roleplay Engine
- **Req-1.1**: Must run on-device quantized Qwen3-0.6B Instruct LLM (GGUF Q4_K_M) via `llama.cpp`.
- **Req-1.2**: Latency for first-token response must be < 800ms on modern desktop/mobile hardware.
- **Req-1.3**: Provides real-time grammatical explanations, vocabulary hints, roleplay, and adaptive dialogue.
- **Req-1.4**: Primary responsibilities restricted to conversation, chat, roleplay, explanations, hint generation, story generation, and adaptive responses.

### 2.2 Translation Provider & Pipeline
- **Req-2.0**: The Translation Provider resolves translations using deterministic linguistic resources (SQLite dictionary, Phrase KB, Morphological Analyzer, Translation Cache). The conversation model is only used as a fallback for constructions that cannot be resolved through the local translation pipeline.
- **Req-2.0.1**: Multi-stage retrieval order: Tap → Phrase Cache → Phrase KB → Dictionary → Morphological Analyzer → Translation Memory → Optional Neural Translator → Qwen Fallback.

### 2.3 Voice Input & Output Pipeline
- **Req-2.1**: Speech-to-Text (STT) executed locally via `Whisper.cpp` (tiny/base models).
- **Req-2.2**: Text-to-Speech (TTS) synthesized locally via `Piper` neural voices.
- **Req-2.3**: Zero streaming of audio data over public internet.

### 2.4 Memory & Spaced Repetition (FSRS v4)
- **Req-3.1**: Implements FSRS v4 algorithm natively in Rust core.
- **Req-3.2**: Tracks retrievability ($R$), stability ($S$), and difficulty ($D$) for every learned word and phrase.
- **Req-3.3**: Supports custom deck imports (Anki `.apkg` format).

### 2.5 Privacy & Local Storage
- **Req-4.1**: SQLite database encrypted via SQLCipher AES-256.
- **Req-4.2**: Vector similarity search integrated via `sqlite-vec` (384-dim embeddings).
- **Req-4.3**: Zero telemetry, zero analytics trackers, zero external phone-home calls.

### 2.6 Dynamic Asset Manifest & Multi-Mirror Pipeline
- **Req-5.1**: No hardcoded model URLs or SHA-256 constants in source code. All assets governed by dynamic `manifest.json`.
- **Req-5.2**: Automatic multi-mirror failover across primary and fallback mirrors (HuggingFace, GitHub Releases, Cloudflare CDN).
- **Req-5.3**: Automatic dynamic SHA-256 calculation and verification upon completion against manifest digest or HTTP headers.
- **Req-5.4**: Versioning and `minimumAppVersion` compatibility enforcement prior to downloading or loading assets.
- **Req-5.5**: Unified asset manifest covers Conversation Models, STT, TTS, Embeddings, Dictionaries, Phrase DBs, Morphology Packs, Grammar Packs, UI Localization Packs, Story Packs, Exercise Packs, and Fonts.

### 2.7 Unified 24-Language Matrix & Application-Wide Localization
- **Req-6.1**: Day 1 support for 24 languages (en, de, fr, es, it, pt, nl, pl, ru, zh, ja, ko, hi, ar, tr, vi, th, id, sv, no, da, fi, el, cs).
- **Req-6.2**: Support all $24 \times 24 = 576$ directional language combinations (e.g., German → Japanese, Hindi → French, Arabic → English). No privileged base language.
- **Req-6.3**: Application-Wide Localization: Selected Source Language translates the entire UI (Navigation, Buttons, Onboarding, Dialogs, Errors, Exercises, Review cards, AI system prompts, RTL support).
- **Req-6.4**: Single Unified Language Registry provides single source of truth for language codes, native/english names, scripts, RTL layout, TTS voices, STT models, dictionary schemas, date/number formatting, and fonts.
