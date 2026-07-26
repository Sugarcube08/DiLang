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
    pub provider: String,
    pub name: String,
    pub filename: String,
    pub version: String,
    pub path: String,
    pub sha256: String,
    pub size_bytes: u64,
    pub runtime_compatibility: String,
    pub status: String, // Downloading, Paused, Downloaded, Verifying, Installed, Corrupted, Updating, Failed
    pub last_verification: String,
    pub active: bool,
    pub installed_at: String,
}

#[derive(Default)]
pub struct ModelManager;

impl ModelManager {
    pub fn new() -> Self {
        Self
    }

    pub fn get_base_dir() -> PathBuf {
        dirs::data_dir()
            .map(|mut p| {
                p.push("DiLang");
                p
            })
            .unwrap_or_else(|| PathBuf::from("./dilang_data"))
    }

    pub fn get_models_dir(subdir: &str) -> PathBuf {
        let mut path = Self::get_base_dir();
        path.push("models");
        if !subdir.is_empty() {
            path.push(subdir);
        }
        let _ = std::fs::create_dir_all(&path);
        path
    }

    pub fn get_downloads_dir() -> PathBuf {
        let mut path = Self::get_base_dir();
        path.push("downloads");
        let _ = std::fs::create_dir_all(&path);
        path
    }

    pub fn get_temp_dir() -> PathBuf {
        let mut path = Self::get_base_dir();
        path.push("temp");
        let _ = std::fs::create_dir_all(&path);
        path
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
               (id, provider, name, filename, version, path, sha256, size_bytes, runtime_compatibility, status, last_verification, active, installed_at) 
               VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13)"#,
            params![
                record.id,
                record.provider,
                record.name,
                record.filename,
                record.version,
                record.path,
                record.sha256,
                record.size_bytes,
                record.runtime_compatibility,
                record.status,
                record.last_verification,
                if record.active { 1 } else { 0 },
                record.installed_at
            ],
        )
        .map_err(|e| AppError::internal(&format!("Failed to register model: {}", e)))?;

        Ok(())
    }

    pub fn list_installed_models(&self) -> CoreResult<Vec<InstalledModelRecord>> {
        let conn = crate::storage::schema::get_connection()
            .map_err(|e| AppError::internal(&format!("DB Error: {}", e)))?;

        let mut stmt = conn.prepare(
            "SELECT id, provider, name, filename, version, path, sha256, size_bytes, runtime_compatibility, status, last_verification, active, installed_at FROM installed_models"
        ).map_err(|e| AppError::internal(&format!("Prepare Query Error: {}", e)))?;

        let rows = stmt
            .query_map([], |row| {
                let active_num: i32 = row.get(11)?;
                Ok(InstalledModelRecord {
                    id: row.get(0)?,
                    provider: row.get(1)?,
                    name: row.get(2)?,
                    filename: row.get(3)?,
                    version: row.get(4)?,
                    path: row.get(5)?,
                    sha256: row.get(6)?,
                    size_bytes: row.get(7)?,
                    runtime_compatibility: row.get(8)?,
                    status: row.get(9)?,
                    last_verification: row.get(10)?,
                    active: active_num != 0,
                    installed_at: row.get(12)?,
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
        let mut target_path = Self::get_models_dir(model_name);
        target_path.push(format!("{}.bin", model_name));

        ModelDownloader::create_local_file(&target_path, content)
            .map_err(|e| AppError::internal(&format!("Failed to create model file: {}", e)))?;

        let actual_sha = FileVerifier::calculate_sha256(&target_path)
            .map_err(|e| AppError::internal(&format!("Failed to calculate SHA-256: {}", e)))?;

        let size = content.len() as u64;
        let record = InstalledModelRecord {
            id: uuid::Uuid::new_v4().to_string(),
            provider: "Local".to_string(),
            name: model_name.to_string(),
            filename: format!("{}.bin", model_name),
            version: version.to_string(),
            path: target_path.to_string_lossy().to_string(),
            sha256: actual_sha.clone(),
            size_bytes: size,
            runtime_compatibility: "v0.1.0".to_string(),
            status: "Installed".to_string(),
            last_verification: Utc::now().to_rfc3339(),
            active: true,
            installed_at: Utc::now().to_rfc3339(),
        };

        self.register_installed_model(&record)?;
        Ok(record)
    }

    pub fn verify_and_register_model(
        &self,
        target_path: &Path,
        model_name: &str,
        provider: &str,
        filename: &str,
        version: &str,
        expected_sha256: &str,
    ) -> CoreResult<InstalledModelRecord> {
        let matches = FileVerifier::verify_sha256(target_path, expected_sha256)
            .map_err(|e| AppError::internal(&format!("SHA-256 error: {}", e)))?;

        if !matches {
            let _ = std::fs::remove_file(target_path);
            return Err(AppError::internal(&format!(
                "SHA-256 checksum verification failed for model {}. Target file deleted.",
                model_name
            )));
        }

        let actual_sha = FileVerifier::calculate_sha256(target_path)
            .unwrap_or_else(|_| expected_sha256.to_string());
        let size = std::fs::metadata(target_path)
            .map(|m| m.len())
            .unwrap_or(0);

        let record = InstalledModelRecord {
            id: uuid::Uuid::new_v4().to_string(),
            provider: provider.to_string(),
            name: model_name.to_string(),
            filename: filename.to_string(),
            version: version.to_string(),
            path: target_path.to_string_lossy().to_string(),
            sha256: actual_sha,
            size_bytes: size,
            runtime_compatibility: "v0.1.0".to_string(),
            status: "Installed".to_string(),
            last_verification: Utc::now().to_rfc3339(),
            active: true,
            installed_at: Utc::now().to_rfc3339(),
        };

        self.register_installed_model(&record)?;
        Ok(record)
    }
}
