//! Review Event Taxonomies

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ReviewEventPayload {
    ReviewScheduled { card_id: String, due_at: String },
    ReviewStarted { card_id: String },
    ReviewCompleted { card_id: String, rating: u8, new_stability: f64 },
    ReviewSkipped { card_id: String },
}
