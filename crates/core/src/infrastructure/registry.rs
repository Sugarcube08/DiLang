//! Production Model & Asset Registry System
//! Supports dynamic HuggingFace API resolution, GitHub Releases failover, dynamic SHA-256 verification, and version compatibility.

use anyhow::Result;
use serde::{Deserialize, Serialize};
use tracing::{info, warn};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RegistryEntry {
    pub id: String,
    #[serde(default)]
    pub name: String,
    pub provider: String,
    #[serde(default = "default_category")]
    pub category: String,
    #[serde(default)]
    pub repository: Option<String>,
    #[serde(default = "default_branch")]
    pub branch: String,
    pub version: String,
    pub filename: String,
    pub storage_directory: String,
    pub download_url: String,
    #[serde(default)]
    pub mirrors: Vec<String>,
    pub sha256: String,
    pub size_bytes: u64,
    pub min_runtime_version: String,
    #[serde(default)]
    pub is_default: bool,
    #[serde(default)]
    pub supported_languages: Vec<String>,
    #[serde(default)]
    pub capabilities: Vec<String>,
    #[serde(default)]
    pub supported_platforms: Vec<String>,
}

fn default_category() -> String {
    "model".to_string()
}

fn default_branch() -> String {
    "main".to_string()
}

impl RegistryEntry {
    /// Formulates HuggingFace download URL dynamically if repository is present
    pub fn get_resolved_huggingface_url(&self) -> Option<String> {
        if let Some(repo) = &self.repository {
            let branch = if self.branch.is_empty() { "main" } else { &self.branch };
            Some(format!(
                "https://huggingface.co/{}/resolve/{}/{}",
                repo, branch, self.filename
            ))
        } else {
            None
        }
    }

    /// Retrieve all prioritized download mirrors (HuggingFace Primary -> GitHub Releases -> Fallback Mirrors)
    pub fn get_all_mirrors(&self) -> Vec<String> {
        let mut list = Vec::new();

        // 1. Primary HuggingFace dynamic URL
        if let Some(hf_url) = self.get_resolved_huggingface_url() {
            list.push(hf_url);
        } else if !self.download_url.is_empty() {
            list.push(self.download_url.clone());
        }

        // 2. Explicit secondary mirrors (e.g. GitHub Releases)
        for mirror in &self.mirrors {
            if !list.contains(mirror) {
                list.push(mirror.clone());
            }
        }
        list
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModelRegistryManifest {
    #[serde(alias = "version")]
    pub manifest_version: String,
    #[serde(default = "default_min_app_ver")]
    pub minimum_app_version: String,
    pub updated_at: String,
    pub models: Vec<RegistryEntry>,
}

fn default_min_app_ver() -> String {
    "1.0.0".to_string()
}

pub struct ModelRegistry;

impl ModelRegistry {
    pub fn get_manifest() -> Result<ModelRegistryManifest> {
        let registry_json = include_str!("../../../../assets/model_registry/registry.json");
        let manifest: ModelRegistryManifest = serde_json::from_str(registry_json)?;
        Ok(manifest)
    }

    /// Queries HuggingFace API (`https://huggingface.co/api/models/{repo}`) for live repo metadata
    pub fn query_huggingface_api(repository: &str) -> Result<serde_json::Value> {
        let api_url = format!("https://huggingface.co/api/models/{}", repository);
        info!("Querying HuggingFace API: {}", api_url);
        let client = reqwest::blocking::Client::builder()
            .user_agent("DiLang-Mobile/1.0.0")
            .timeout(std::time::Duration::from_secs(10))
            .build()?;

        let resp = client.get(&api_url).send()?;
        if resp.status().is_success() {
            let json_val = resp.json::<serde_json::Value>()?;
            Ok(json_val)
        } else {
            anyhow::bail!("HuggingFace API returned HTTP {}", resp.status());
        }
    }

    pub fn fetch_remote_manifest(remote_url: &str) -> Result<ModelRegistryManifest> {
        info!("Fetching remote asset manifest from: {}", remote_url);
        let client = reqwest::blocking::Client::builder()
            .timeout(std::time::Duration::from_secs(10))
            .build()?;

        match client.get(remote_url).send() {
            Ok(resp) if resp.status().is_success() => {
                let text = resp.text()?;
                let manifest: ModelRegistryManifest = serde_json::from_str(&text)?;
                info!(
                    "Successfully fetched remote manifest version: {}",
                    manifest.manifest_version
                );
                Ok(manifest)
            }
            Err(e) => {
                warn!(
                    "Failed to fetch remote manifest from {}: {}. Falling back to bundled manifest.",
                    remote_url, e
                );
                Self::get_manifest()
            }
            Ok(resp) => {
                warn!(
                    "Remote manifest URL returned HTTP status: {}. Falling back to bundled manifest.",
                    resp.status()
                );
                Self::get_manifest()
            }
        }
    }

    pub fn get_entry(model_id: &str) -> Result<Option<RegistryEntry>> {
        let manifest = Self::get_manifest()?;
        if let Some(entry) = manifest.models.into_iter().find(|m| m.id == model_id) {
            return Ok(Some(entry));
        }

        // Dynamic Fallback for Piper TTS Voices (e.g. piper-de_DE-thorsten-medium)
        if model_id.starts_with("piper-") {
            let parts: Vec<&str> = model_id.split('-').collect();
            if parts.len() >= 4 {
                let locale = parts[1]; // e.g. de_DE
                let speaker = parts[2]; // e.g. thorsten
                let quality = parts[3]; // e.g. medium
                let lang_prefix = locale.split('_').next().unwrap_or("en");

                let rel_path = format!("{}/{}/{}/{}/{}-{}-{}.onnx", lang_prefix, locale, speaker, quality, locale, speaker, quality);
                let hf_url = format!("https://huggingface.co/rhasspy/piper-voices/resolve/main/{}", rel_path);

                return Ok(Some(RegistryEntry {
                    id: model_id.to_string(),
                    name: format!("Piper Voice ({})", locale),
                    provider: "huggingface".to_string(),
                    category: "tts".to_string(),
                    repository: Some("rhasspy/piper-voices".to_string()),
                    branch: "main".to_string(),
                    version: "1.0.0".to_string(),
                    filename: format!("{}-{}-{}.onnx", locale, speaker, quality),
                    storage_directory: "piper".to_string(),
                    download_url: hf_url.clone(),
                    mirrors: vec![hf_url],
                    sha256: "".to_string(),
                    size_bytes: 63201294,
                    min_runtime_version: "1.0.0".to_string(),
                    is_default: false,
                    supported_languages: vec![lang_prefix.to_string()],
                    capabilities: vec!["tts".to_string(), "speech_synthesis".to_string()],
                    supported_platforms: vec!["linux".to_string(), "android".to_string(), "macos".to_string(), "windows".to_string()],
                }));
            }
        }

        Ok(None)
    }

    pub fn list_entries() -> Result<Vec<RegistryEntry>> {
        let manifest = Self::get_manifest()?;
        Ok(manifest.models)
    }
}
