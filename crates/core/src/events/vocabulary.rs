//! Vocabulary Event Taxonomies

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum VocabularyEventPayload {
    VocabularyDetected { term: String, cefr_level: String },
    VocabularyMastered { term: String },
    VocabularyForgotten { term: String },
    VocabularyReviewed { term: String, rating: u8 },
}
