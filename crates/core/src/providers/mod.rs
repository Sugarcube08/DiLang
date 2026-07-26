//! AI Provider Trait Abstractions (llama.cpp, Whisper.cpp, Piper ONNX)

use anyhow::Result;

pub trait LlamaProvider: Send + Sync {
    fn generate(&self, prompt: &str) -> Result<String>;
}

pub trait WhisperProvider: Send + Sync {
    fn transcribe_pcm(&self, pcm_data: &[f32]) -> Result<String>;
}

pub trait PiperProvider: Send + Sync {
    fn synthesize_pcm(&self, text: &str) -> Result<Vec<u8>>;
}
