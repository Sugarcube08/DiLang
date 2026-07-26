//! Settings Repository Contract

use anyhow::Result;
use crate::models::Settings;

pub trait SettingsRepositoryContract: Send + Sync {
    fn load(&self) -> Result<Settings>;
    fn update(&self, settings: &Settings) -> Result<()>;
}
