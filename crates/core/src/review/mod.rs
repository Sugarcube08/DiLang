//! FSRS Spaced Repetition Review Queue Interface

use anyhow::Result;
use crate::models::ReviewCard;

pub trait ReviewEngine: Send + Sync {
    fn fetch_due_cards(&self, limit: usize) -> Result<Vec<ReviewCard>>;
    fn submit_review(&self, card_id: &str, rating: u8) -> Result<ReviewCard>;
}
