//! Grammar Event Taxonomies

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum GrammarEventPayload {
    GrammarDetected { rule_pattern: String },
    GrammarWeaknessFound { rule_pattern: String, mistake: String },
    GrammarMastered { rule_pattern: String },
}
