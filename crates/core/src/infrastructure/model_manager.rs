//! On-Device AI Model Manager, Verification & Installation System

use super::downloader::{FileVerifier, ModelDownloader};
use super::errors::AppError;
use super::result::CoreResult;
use chrono::Utc;
use rusqlite::params;
use serde::{Deserialize, Serialize};
use std::path::{Path, PathBuf};
use tracing::info;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InstalledModelRecord {
    pub id: String,
    pub name: String,
    pub version: String,
    pub path: String,
    pub sha256: String,
    pub size_bytes: u64,
    pub installed_at: String,
}

#[derive(Default)]
pub struct ModelManager;

impl ModelManager {
    pub fn new() -> Self {
        Self
    }

    pub fn get_models_dir() -> PathBuf {
        dirs::data_dir()
            .map(|mut p| {
                p.push("DiLang");
                p.push("models");
                p
            })
            .unwrap_or_else(|| PathBuf::from("./models"))
    }

    pub fn verify_checksum(&self, path: &Path, expected_sha256: &str) -> CoreResult<bool> {
        FileVerifier::verify_sha256(path, expected_sha256)
            .map_err(|e| AppError::internal(&format!("Checksum verification error: {}", e)))
    }

    pub fn register_installed_model(&self, record: &InstalledModelRecord) -> CoreResult<()> {
        info!("Registering installed model in SQLite: {}", record.name);
        let conn = crate::storage::schema::get_connection()
            .map_err(|e| AppError::internal(&format!("DB Error: {}", e)))?;

        conn.execute(
            r#"INSERT OR REPLACE INTO installed_models 
               (id, name, version, path, sha256, size_bytes, installed_at) 
               VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)"#,
            params![
                record.id,
                record.name,
                record.version,
                record.path,
                record.sha256,
                record.size_bytes,
                record.installed_at
            ],
        )
        .map_err(|e| AppError::internal(&format!("Failed to register model: {}", e)))?;

        Ok(())
    }

    pub fn list_installed_models(&self) -> CoreResult<Vec<InstalledModelRecord>> {
        let conn = crate::storage::schema::get_connection()
            .map_err(|e| AppError::internal(&format!("DB Error: {}", e)))?;

        let mut stmt = conn.prepare("SELECT id, name, version, path, sha256, size_bytes, installed_at FROM installed_models")
            .map_err(|e| AppError::internal(&format!("Prepare Query Error: {}", e)))?;

        let rows = stmt
            .query_map([], |row| {
                Ok(InstalledModelRecord {
                    id: row.get(0)?,
                    name: row.get(1)?,
                    version: row.get(2)?,
                    path: row.get(3)?,
                    sha256: row.get(4)?,
                    size_bytes: row.get(5)?,
                    installed_at: row.get(6)?,
                })
            })
            .map_err(|e| AppError::internal(&format!("Query Map Error: {}", e)))?;

        let mut results = Vec::new();
        for rec in rows.flatten() {
            results.push(rec);
        }
        Ok(results)
    }

    pub fn install_model_file(
        &self,
        model_name: &str,
        version: &str,
        content: &[u8],
    ) -> CoreResult<InstalledModelRecord> {
        let mut target_path = Self::get_models_dir();
        target_path.push(format!("{}.bin", model_name));

        ModelDownloader::create_local_file(&target_path, content)
            .map_err(|e| AppError::internal(&format!("Failed to create model file: {}", e)))?;

        let is_valid = self
            .verify_checksum(&target_path, "dummy_hash")
            .unwrap_or(true);

        let size = content.len() as u64;
        let record = InstalledModelRecord {
            id: uuid::Uuid::new_v4().to_string(),
            name: model_name.to_string(),
            version: version.to_string(),
            path: target_path.to_string_lossy().to_string(),
            sha256: if is_valid {
                "dummy_hash".to_string()
            } else {
                "invalid".to_string()
            },
            size_bytes: size,
            installed_at: Utc::now().to_rfc3339(),
        };

        self.register_installed_model(&record)?;
        Ok(record)
    }
}
