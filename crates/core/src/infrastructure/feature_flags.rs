//! Lightweight Feature Flags System

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FeatureFlags {
    pub conversation: bool,
    pub review: bool,
    pub embeddings: bool,
    pub local_sync: bool,
    pub cloud_backup: bool,
    pub experimental_models: bool,
}

impl Default for FeatureFlags {
    fn default() -> Self {
        Self {
            conversation: true,
            review: true,
            embeddings: true,
            local_sync: true,
            cloud_backup: false,
            experimental_models: false,
        }
    }
}

impl FeatureFlags {
    pub fn is_enabled(&self, flag: &str) -> bool {
        match flag {
            "conversation" => self.conversation,
            "review" => self.review,
            "embeddings" => self.embeddings,
            "local_sync" => self.local_sync,
            "cloud_backup" => self.cloud_backup,
            "experimental_models" => self.experimental_models,
            _ => false,
        }
    }
}
