//! Real HTTP Downloader, Streamed Chunked Transfer & File Verifier Infrastructure

use super::errors::AppError;
use super::registry::RegistryEntry;
use super::result::CoreResult;
use anyhow::Result;
use sha2::{Digest, Sha256};
use std::fs::{File, OpenOptions};
use std::io::{Read, Write};
use std::path::{Path, PathBuf};
use std::time::Instant;
use tracing::info;

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct DownloadProgress {
    pub model_id: String,
    pub bytes_downloaded: u64,
    pub total_bytes: u64,
    pub bytes_per_sec: u64,
    pub eta_seconds: u64,
    pub status: String,
}

pub struct FileVerifier;

impl FileVerifier {
    pub fn calculate_sha256(file_path: &Path) -> Result<String> {
        info!("Calculating SHA-256 for file: {:?}", file_path);
        let mut file = File::open(file_path)?;
        let mut hasher = Sha256::new();
        let mut buffer = [0u8; 65536];
        loop {
            let n = file.read(&mut buffer)?;
            if n == 0 {
                break;
            }
            hasher.update(&buffer[..n]);
        }
        let hash_result = format!("{:x}", hasher.finalize());
        info!("SHA-256 calculated: {}", hash_result);
        Ok(hash_result)
    }

    pub fn verify_sha256(file_path: &Path, expected_sha256: &str) -> Result<bool> {
        let hash_result = Self::calculate_sha256(file_path)?;
        let matches = hash_result.eq_ignore_ascii_case(expected_sha256);
        info!(
            "SHA-256 verification: calculated={}, expected={}, match={}",
            hash_result, expected_sha256, matches
        );
        Ok(matches)
    }
}

pub struct ModelDownloader;

impl ModelDownloader {
    pub fn create_local_file(target_path: &Path, dummy_content: &[u8]) -> Result<()> {
        if let Some(parent) = target_path.parent() {
            std::fs::create_dir_all(parent)?;
        }
        let mut file = File::create(target_path)?;
        file.write_all(dummy_content)?;
        file.flush()?;
        Ok(())
    }

    pub fn download_model_entry<F>(
        entry: &RegistryEntry,
        dest_dir: &Path,
        progress_cb: F,
    ) -> CoreResult<PathBuf>
    where
        F: Fn(DownloadProgress),
    {
        info!(
            "Starting HTTP streamed download for model '{}' from URL: {}",
            entry.id, entry.download_url
        );

        let final_path = dest_dir.join(&entry.filename);
        if final_path.exists() {
            info!("Model file already exists at: {:?}", final_path);
            if FileVerifier::verify_sha256(&final_path, &entry.sha256).unwrap_or(false) {
                info!("Existing model file SHA-256 verified successfully.");
                progress_cb(DownloadProgress {
                    model_id: entry.id.clone(),
                    bytes_downloaded: entry.size_bytes,
                    total_bytes: entry.size_bytes,
                    bytes_per_sec: 0,
                    eta_seconds: 0,
                    status: "Installed".to_string(),
                });
                return Ok(final_path);
            } else {
                info!("Existing file failed checksum. Deleting and re-downloading.");
                let _ = std::fs::remove_file(&final_path);
            }
        }

        let temp_dir = super::model_manager::ModelManager::get_downloads_dir();
        let part_path = temp_dir.join(format!("{}.part", entry.filename));

        let mut existing_bytes: u64 = 0;
        if part_path.exists() {
            if let Ok(meta) = std::fs::metadata(&part_path) {
                existing_bytes = meta.len();
                info!("Resuming download from byte offset: {}", existing_bytes);
            }
        }

        let client = reqwest::blocking::Client::builder()
            .timeout(std::time::Duration::from_secs(300))
            .build()
            .map_err(|e| AppError::internal(&format!("Failed to build HTTP client: {}", e)))?;

        let mut req = client.get(&entry.download_url);
        if existing_bytes > 0 {
            req = req.header("Range", format!("bytes={}-", existing_bytes));
        }

        let mut response = req
            .send()
            .map_err(|e| AppError::internal(&format!("HTTP request failed: {}", e)))?;

        if !response.status().is_success() && response.status() != reqwest::StatusCode::PARTIAL_CONTENT {
            return Err(AppError::internal(&format!(
                "HTTP download server returned status: {}",
                response.status()
            )));
        }

        let total_bytes = entry.size_bytes.max(existing_bytes);
        let mut file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(&part_path)
            .map_err(|e| AppError::internal(&format!("Failed to open .part file: {}", e)))?;

        let mut downloaded_bytes = existing_bytes;
        let mut buffer = [0u8; 65536];
        let start_time = Instant::now();
        let mut last_emit = Instant::now();

        loop {
            let n = match response.read(&mut buffer) {
                Ok(0) => break,
                Ok(bytes_read) => bytes_read,
                Err(e) => {
                    return Err(AppError::internal(&format!("Error reading HTTP stream: {}", e)));
                }
            };

            file.write_all(&buffer[..n])
                .map_err(|e| AppError::internal(&format!("Error writing to .part file: {}", e)))?;
            downloaded_bytes += n as u64;

            if last_emit.elapsed().as_millis() >= 200 || downloaded_bytes >= total_bytes {
                let elapsed_secs = start_time.elapsed().as_secs_f64().max(0.001);
                let bytes_diff = downloaded_bytes.saturating_sub(existing_bytes);
                let speed = (bytes_diff as f64 / elapsed_secs) as u64;
                let remaining_bytes = total_bytes.saturating_sub(downloaded_bytes);
                let eta = remaining_bytes.checked_div(speed).unwrap_or(0);

                progress_cb(DownloadProgress {
                    model_id: entry.id.clone(),
                    bytes_downloaded: downloaded_bytes,
                    total_bytes,
                    bytes_per_sec: speed,
                    eta_seconds: eta,
                    status: "Downloading".to_string(),
                });
                last_emit = Instant::now();
            }
        }
        file.flush()
            .map_err(|e| AppError::internal(&format!("Flush error: {}", e)))?;

        // Perform SHA-256 verification on completed .part file
        progress_cb(DownloadProgress {
            model_id: entry.id.clone(),
            bytes_downloaded: downloaded_bytes,
            total_bytes,
            bytes_per_sec: 0,
            eta_seconds: 0,
            status: "Verifying".to_string(),
        });

        info!("Verifying SHA-256 checksum for downloaded file: {:?}", part_path);
        let calculated_sha = FileVerifier::calculate_sha256(&part_path)
            .map_err(|e| AppError::internal(&format!("Checksum calculation failed: {}", e)))?;

        if !calculated_sha.eq_ignore_ascii_case(&entry.sha256) {
            info!(
                "SHA-256 MISMATCH for {}: calculated={}, expected={}. Deleting .part file.",
                entry.id, calculated_sha, entry.sha256
            );
            let _ = std::fs::remove_file(&part_path);
            return Err(AppError::internal(&format!(
                "SHA-256 checksum verification failed for model {}. Downloaded .part file deleted.",
                entry.id
            )));
        }

        // Atomic rename from .part to final target path
        if let Some(parent) = final_path.parent() {
            std::fs::create_dir_all(parent)
                .map_err(|e| AppError::internal(&format!("Create dir error: {}", e)))?;
        }
        std::fs::rename(&part_path, &final_path)
            .map_err(|e| AppError::internal(&format!("Atomic rename failed: {}", e)))?;

        info!("Model '{}' installed atomically to {:?}", entry.id, final_path);
        progress_cb(DownloadProgress {
            model_id: entry.id.clone(),
            bytes_downloaded: total_bytes,
            total_bytes,
            bytes_per_sec: 0,
            eta_seconds: 0,
            status: "Installed".to_string(),
        });

        Ok(final_path)
    }
}
