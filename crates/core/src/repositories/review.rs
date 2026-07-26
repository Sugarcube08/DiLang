//! Review Repository Contract

use crate::models::ReviewCard;
use anyhow::Result;

pub trait ReviewRepositoryContract: Send + Sync {
    fn next(&self) -> Result<Option<ReviewCard>>;
    fn complete(&self, card_id: &str, rating: u8) -> Result<ReviewCard>;
    fn skip(&self, card_id: &str) -> Result<()>;
    fn statistics(&self) -> Result<String>;
}
