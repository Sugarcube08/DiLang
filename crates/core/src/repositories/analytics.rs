//! Analytics Repository Contract

use anyhow::Result;
use crate::models::ProgressSnapshot;

pub trait AnalyticsRepositoryContract: Send + Sync {
    fn snapshot(&self) -> Result<ProgressSnapshot>;
    fn dashboard(&self) -> Result<String>;
    fn history(&self) -> Result<Vec<String>>;
    fn export(&self) -> Result<Vec<u8>>;
}
