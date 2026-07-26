//! Analytics Event Taxonomies

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum AnalyticsEventPayload {
    ProgressUpdated {
        total_words: u32,
        retention_rate: f32,
    },
    DashboardChanged {
        active_tab: String,
    },
    CEFRUpdated {
        new_level: String,
    },
    LearningSessionEnded {
        duration_seconds: u32,
        cards_reviewed: u32,
    },
}
