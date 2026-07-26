//! Settings Repository Contract & SQLite Storage Implementation

use anyhow::Result;
use rusqlite::params;
use tracing::info;
use crate::models::Settings;
use crate::storage::schema::get_connection;

pub trait SettingsRepositoryContract: Send + Sync {
    fn load(&self) -> Result<Settings>;
    fn update(&self, settings: &Settings) -> Result<()>;
}

pub struct SettingsRepositoryImpl;

impl SettingsRepositoryImpl {
    pub fn new() -> Self {
        Self
    }
}

impl SettingsRepositoryContract for SettingsRepositoryImpl {
    fn load(&self) -> Result<Settings> {
        let conn = get_connection()?;
        let mut settings = Settings::default();

        let mut stmt = conn.prepare("SELECT key, value FROM settings")?;
        let rows = stmt.query_map([], |row| Ok((row.get::<_, String>(0)?, row.get::<_, String>(1)?)))?;

        for r in rows {
            if let Ok((k, v)) = r {
                match k.as_str() {
                    "theme_mode" => settings.theme_mode = v,
                    "is_offline_mode" => settings.is_offline_mode = v == "true",
                    "model_quantization" => settings.model_quantization = v,
                    "auto_play_audio" => settings.auto_play_audio = v == "true",
                    _ => {}
                }
            }
        }

        Ok(settings)
    }

    fn update(&self, settings: &Settings) -> Result<()> {
        info!("Persisting settings to SQLite database...");
        let conn = get_connection()?;

        let pairs = [
            ("theme_mode", settings.theme_mode.as_str()),
            ("is_offline_mode", if settings.is_offline_mode { "true" } else { "false" }),
            ("model_quantization", settings.model_quantization.as_str()),
            ("auto_play_audio", if settings.auto_play_audio { "true" } else { "false" }),
        ];

        for (k, v) in pairs {
            conn.execute("INSERT OR REPLACE INTO settings (key, value) VALUES (?1, ?2)", params![k, v])?;
        }

        Ok(())
    }
}
