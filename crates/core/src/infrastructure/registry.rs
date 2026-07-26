//! Production Model Registry System
//! Loads and validates assets/model_registry/registry.json metadata

use anyhow::Result;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RegistryEntry {
    pub id: String,
    pub provider: String,
    pub version: String,
    pub filename: String,
    pub storage_directory: String,
    pub download_url: String,
    pub sha256: String,
    pub size_bytes: u64,
    pub min_runtime_version: String,
    pub supported_os: Vec<String>,
    pub supported_arch: Vec<String>,
    pub dependencies: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ModelRegistryManifest {
    pub version: String,
    pub updated_at: String,
    pub models: Vec<RegistryEntry>,
}

pub struct ModelRegistry;

impl ModelRegistry {
    pub fn get_manifest() -> Result<ModelRegistryManifest> {
        let registry_json = include_str!("../../../../assets/model_registry/registry.json");
        let manifest: ModelRegistryManifest = serde_json::from_str(registry_json)?;
        Ok(manifest)
    }

    pub fn get_entry(model_id: &str) -> Result<Option<RegistryEntry>> {
        let manifest = Self::get_manifest()?;
        Ok(manifest.models.into_iter().find(|m| m.id == model_id))
    }

    pub fn list_entries() -> Result<Vec<RegistryEntry>> {
        let manifest = Self::get_manifest()?;
        Ok(manifest.models)
    }
}
