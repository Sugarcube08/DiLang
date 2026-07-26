//! Single Source of Truth Configuration Manager

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIConfig {
    pub default_llm_model: String,
    pub quantization_profile: String,
    pub context_window: u32,
}

impl Default for AIConfig {
    fn default() -> Self {
        Self {
            default_llm_model: "gemma-3-1b-it".to_string(),
            quantization_profile: "Q4_K_M".to_string(),
            context_window: 2048,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StorageConfig {
    pub db_filename: String,
    pub encryption_enabled: bool,
    pub vector_dimensions: u32,
}

impl Default for StorageConfig {
    fn default() -> Self {
        Self {
            db_filename: "database.db".to_string(),
            encryption_enabled: true,
            vector_dimensions: 384,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SyncConfig {
    pub p2p_discovery_enabled: bool,
    pub sync_interval_seconds: u32,
}

impl Default for SyncConfig {
    fn default() -> Self {
        Self {
            p2p_discovery_enabled: true,
            sync_interval_seconds: 300,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AudioConfig {
    pub sample_rate: u32,
    pub stt_model: String,
    pub tts_voice_id: String,
}

impl Default for AudioConfig {
    fn default() -> Self {
        Self {
            sample_rate: 16000,
            stt_model: "whisper-base".to_string(),
            tts_voice_id: "piper-en-us".to_string(),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct AppConfig {
    pub ai: AIConfig,
    pub storage: StorageConfig,
    pub sync: SyncConfig,
    pub audio: AudioConfig,
}

#[derive(Default)]
pub struct ConfigManager {
    config: AppConfig,
}

impl ConfigManager {
    pub fn new() -> Self {
        Self {
            config: AppConfig::default(),
        }
    }

    pub fn get(&self) -> &AppConfig {
        &self.config
    }
}
