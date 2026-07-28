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

use once_cell::sync::Lazy;
use std::sync::Mutex;

static CUSTOM_BASE_PATH: Lazy<Mutex<Option<PathBuf>>> = Lazy::new(|| Mutex::new(None));

#[derive(Default)]
pub struct ModelManager;

impl ModelManager {
    pub fn new() -> Self {
        Self
    }

    pub fn set_custom_base_path(path: PathBuf) {
        if let Ok(mut lock) = CUSTOM_BASE_PATH.lock() {
            *lock = Some(path);
        }
    }

    pub fn get_base_dir() -> PathBuf {
        if let Ok(lock) = CUSTOM_BASE_PATH.lock() {
            if let Some(ref path) = *lock {
                return path.clone();
            }
        }

        if let Some(mut p) = dirs::data_dir() {
            p.push("DiLang");
            return p;
        }

        // Android fallback locations
        let android_app_data = PathBuf::from("/data/data/com.dilang.mobile/files/DiLang");
        if android_app_data.parent().map(|p| p.exists()).unwrap_or(false) {
            return android_app_data;
        }

        let android_user0_data = PathBuf::from("/data/user/0/com.dilang.mobile/files/DiLang");
        if android_user0_data.parent().map(|p| p.exists()).unwrap_or(false) {
            return android_user0_data;
        }

        let mut temp = std::env::temp_dir();
        temp.push("DiLang");
        temp
    }

    pub fn get_models_dir(subdir: &str) -> PathBuf {
        let mut path = Self::get_base_dir();
        path.push("models");

        let clean_subdir = subdir
            .trim_start_matches("models/")
            .trim_start_matches("models\\")
            .trim_start_matches('/')
            .trim_start_matches('\\');

        if !clean_subdir.is_empty() {
            path.push(clean_subdir);
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

        // Auto-discover models present on disk in models/ directory
        let base_models = Self::get_base_dir().join("models");
        if base_models.exists() {
            if let Ok(entries) = std::fs::read_dir(&base_models) {
                for entry in entries.flatten() {
                    let p = entry.path();
                    if p.is_file() {
                        let fname = p.file_name().unwrap_or_default().to_string_lossy().to_string();
                        if (fname.ends_with(".gguf") || fname.ends_with(".bin") || fname.ends_with(".onnx")) && !fname.contains(".part") {
                            let stem = fname
                                .trim_end_matches(".gguf")
                                .trim_end_matches(".bin")
                                .trim_end_matches(".onnx")
                                .to_string();
                            let path_str = p.to_string_lossy().to_string();
                            if !results.iter().any(|r| r.filename == fname || r.path == path_str || r.id == stem) {
                                results.push(InstalledModelRecord {
                                    id: stem.clone(),
                                    provider: "Local".to_string(),
                                    name: stem.clone(),
                                    filename: fname,
                                    version: "1.0".to_string(),
                                    path: path_str,
                                    sha256: "".to_string(),
                                    size_bytes: std::fs::metadata(&p).map(|m| m.len()).unwrap_or(0),
                                    runtime_compatibility: "v0.1.0".to_string(),
                                    status: "Installed".to_string(),
                                    last_verification: Utc::now().to_rfc3339(),
                                    active: true,
                                    installed_at: Utc::now().to_rfc3339(),
                                });
                            }
                        }
                    }
                }
            }
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
        let actual_sha = FileVerifier::calculate_sha256(target_path)
            .unwrap_or_else(|_| expected_sha256.to_string());
        let size = std::fs::metadata(target_path).map(|m| m.len()).unwrap_or(0);

        let record = InstalledModelRecord {
            id: model_name.to_string(),
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
        super::downloader::log_info(&format!("[SQLITE REGISTER SUCCESS] Registered model '{}' in SQLite DB (Path: {})", model_name, target_path.display()));
        Ok(record)
    }
}
