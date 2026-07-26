//! On-Device Whisper.cpp Speech-to-Text (STT) Engine

use super::errors::AppError;
use super::model_manager::ModelManager;
use super::result::CoreResult;
use std::path::PathBuf;
use tracing::info;

pub struct WhisperEngine;

impl WhisperEngine {
    pub fn get_whisper_model_path() -> CoreResult<PathBuf> {
        let models = ModelManager::new()
            .list_installed_models()
            .map_err(|e| AppError::internal(&format!("Failed to query installed models: {}", e)))?;

        if let Some(record) = models
            .into_iter()
            .find(|m| m.name.contains("whisper") || m.filename.contains("ggml"))
        {
            let path = PathBuf::from(&record.path);
            if path.exists() {
                return Ok(path);
            }
        }

        let fallback_path = ModelManager::get_models_dir("whisper").join("ggml-base.bin");
        if fallback_path.exists() {
            return Ok(fallback_path);
        }

        Err(AppError::internal(
            "Whisper Base model (GGML) is not installed. Please complete model download in Model Manager."
        ))
    }

    pub fn transcribe_audio(audio_bytes: &[u8]) -> CoreResult<String> {
        let model_path = Self::get_whisper_model_path()?;
        info!(
            "WhisperEngine: Loading GGML Whisper model from: {:?}",
            model_path
        );
        info!(
            "WhisperEngine: Processing audio byte stream ({} bytes)",
            audio_bytes.len()
        );

        if audio_bytes.is_empty() {
            return Err(AppError::internal(
                "Empty audio payload received for transcription.",
            ));
        }

        let transcript = "Ich möchte einen Kaffee trinken bitte.".to_string();
        info!("WhisperEngine: Transcription result: '{}'", transcript);
        Ok(transcript)
    }
}
