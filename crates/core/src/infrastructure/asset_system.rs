use super::downloader::log_info;
use super::errors::AppError;
use super::result::CoreResult;
use chrono::Utc;
use rusqlite::params;
use serde::{Deserialize, Serialize};
use std::fmt;
use std::path::{Path, PathBuf};

#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct AssetId(pub String);

impl AssetId {
    pub fn new(id: impl Into<String>) -> Self {
        Self(id.into().trim().to_lowercase())
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl fmt::Display for AssetId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum AssetCategory {
    LlamaModel,
    WhisperModel,
    PiperVoice,
    EmbeddingModel,
    DictionaryPack,
    GrammarPack,
    LocalizationPack,
}

impl AssetCategory {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::LlamaModel => "LlamaModel",
            Self::WhisperModel => "WhisperModel",
            Self::PiperVoice => "PiperVoice",
            Self::EmbeddingModel => "EmbeddingModel",
            Self::DictionaryPack => "DictionaryPack",
            Self::GrammarPack => "GrammarPack",
            Self::LocalizationPack => "LocalizationPack",
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum AssetState {
    NotInstalled,
    Queued,
    Downloading,
    Paused,
    Downloaded,
    Verifying,
    Verified,
    Installing,
    Installed,
    Corrupted,
    Failed,
}

impl AssetState {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::NotInstalled => "NotInstalled",
            Self::Queued => "Queued",
            Self::Downloading => "Downloading",
            Self::Paused => "Paused",
            Self::Downloaded => "Downloaded",
            Self::Verifying => "Verifying",
            Self::Verified => "Verified",
            Self::Installing => "Installing",
            Self::Installed => "Installed",
            Self::Corrupted => "Corrupted",
            Self::Failed => "Failed",
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum SystemCapability {
    ConversationLlm,
    SpeechRecognition,
    SpeechSynthesis,
    PhoneticAnalysis,
}

impl SystemCapability {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::ConversationLlm => "ConversationLlm",
            Self::SpeechRecognition => "SpeechRecognition",
            Self::SpeechSynthesis => "SpeechSynthesis",
            Self::PhoneticAnalysis => "PhoneticAnalysis",
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GenericAsset {
    pub id: AssetId,
    pub category: AssetCategory,
    pub name: String,
    pub provider: String,
    pub filename: String,
    pub version: String,
    pub size_bytes: u64,
    pub sha256: String,
    pub path: String,
    pub state: AssetState,
    pub required_capability: Option<SystemCapability>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CapabilityStatus {
    pub capability: SystemCapability,
    pub is_ready: bool,
    pub active_asset_id: Option<AssetId>,
}

pub struct UnifiedAssetManager;

impl UnifiedAssetManager {
    pub fn new() -> Self {
        Self
    }

    /// Rebuilds SQLite cache automatically by scanning physical disk assets
    pub fn sync_and_rebuild_cache(&self) -> CoreResult<Vec<GenericAsset>> {
        log_info("[ASSET MANAGER] Rebuilding asset cache from filesystem source of truth...");
        let base_dir = super::model_manager::ModelManager::get_base_dir();
        let models_dir = base_dir.join("models");

        let mut discovered = Vec::new();

        fn scan_recursive(dir: &Path, acc: &mut Vec<PathBuf>) {
            if let Ok(entries) = std::fs::read_dir(dir) {
                for entry in entries.flatten() {
                    let p = entry.path();
                    if p.is_dir() {
                        scan_recursive(&p, acc);
                    } else if p.is_file() {
                        acc.push(p);
                    }
                }
            }
        }

        let mut file_paths = Vec::new();
        if models_dir.exists() {
            scan_recursive(&models_dir, &mut file_paths);
        }

        for path in file_paths {
            let fname = path
                .file_name()
                .unwrap_or_default()
                .to_string_lossy()
                .to_string();
            if fname.contains(".part") {
                continue;
            }

            let stem = fname
                .trim_end_matches(".gguf")
                .trim_end_matches(".bin")
                .trim_end_matches(".onnx")
                .to_string();

            let lower_path = path.to_string_lossy().to_lowercase();
            let (category, cap) = if lower_path.contains("qwen") || fname.ends_with(".gguf") {
                (
                    AssetCategory::LlamaModel,
                    Some(SystemCapability::ConversationLlm),
                )
            } else if lower_path.contains("whisper") {
                (
                    AssetCategory::WhisperModel,
                    Some(SystemCapability::SpeechRecognition),
                )
            } else if lower_path.contains("piper") || fname.ends_with(".onnx") {
                (
                    AssetCategory::PiperVoice,
                    Some(SystemCapability::SpeechSynthesis),
                )
            } else {
                (AssetCategory::DictionaryPack, None)
            };

            let size = std::fs::metadata(&path).map(|m| m.len()).unwrap_or(0);

            let asset = GenericAsset {
                id: AssetId::new(&stem),
                category,
                name: stem.clone(),
                provider: "LocalDisk".to_string(),
                filename: fname,
                version: "1.0".to_string(),
                size_bytes: size,
                sha256: "".to_string(),
                path: path.to_string_lossy().to_string(),
                state: AssetState::Installed,
                required_capability: cap,
            };

            self.register_in_sqlite(&asset)?;
            discovered.push(asset);
        }

        log_info(&format!(
            "[ASSET MANAGER SUCCESS] Rebuilt asset cache with {} verified disk assets",
            discovered.len()
        ));
        Ok(discovered)
    }

    pub fn register_in_sqlite(&self, asset: &GenericAsset) -> CoreResult<()> {
        let conn = crate::storage::schema::get_connection()
            .map_err(|e| AppError::internal(&format!("DB Error: {}", e)))?;

        let cap_str = asset.required_capability.map(|c| c.as_str()).unwrap_or("");

        conn.execute(
            r#"INSERT OR REPLACE INTO installed_models 
               (id, provider, name, filename, version, path, sha256, size_bytes, runtime_compatibility, status, last_verification, active, installed_at) 
               VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, 1, ?12)"#,
            params![
                asset.id.as_str(),
                asset.provider,
                asset.name,
                asset.filename,
                asset.version,
                asset.path,
                asset.sha256,
                asset.size_bytes,
                cap_str,
                asset.state.as_str(),
                Utc::now().to_rfc3339(),
                Utc::now().to_rfc3339()
            ],
        )
        .map_err(|e| AppError::internal(&format!("Failed to register asset in SQLite: {}", e)))?;

        Ok(())
    }

    pub fn evaluate_capabilities(&self) -> Vec<CapabilityStatus> {
        let assets = self.sync_and_rebuild_cache().unwrap_or_default();

        let capabilities = vec![
            SystemCapability::ConversationLlm,
            SystemCapability::SpeechRecognition,
            SystemCapability::SpeechSynthesis,
        ];

        capabilities
            .into_iter()
            .map(|cap| {
                let active = assets.iter().find(|a| {
                    a.required_capability == Some(cap) && Path::new(&a.path).exists()
                });
                CapabilityStatus {
                    capability: cap,
                    is_ready: active.is_some(),
                    active_asset_id: active.map(|a| a.id.clone()),
                }
            })
            .collect()
    }

    pub fn check_overall_readiness(&self) -> bool {
        let statuses = self.evaluate_capabilities();
        statuses.iter().all(|s| s.is_ready)
    }
}
