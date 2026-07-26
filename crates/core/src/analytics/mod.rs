//! Privacy-Preserving Local Analytics Interface

use anyhow::Result;
use crate::models::ProgressSnapshot;

pub trait AnalyticsEngine: Send + Sync {
    fn compute_snapshot(&self) -> Result<ProgressSnapshot>;
}
