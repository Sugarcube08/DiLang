//! DiLang Local AI Orchestrator
//!
//! Manages runtimes for llama.cpp (Gemma 3 1B), Whisper.cpp (speech-to-text),
//! and Piper (text-to-speech). Encapsulates memory management and hardware acceleration.

pub mod llm;
pub mod stt;
pub mod tts;

pub struct LocalAiOrchestrator;
