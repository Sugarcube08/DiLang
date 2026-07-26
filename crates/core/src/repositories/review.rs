//! Review Repository Contract

use anyhow::Result;
use crate::models::ReviewCard;

pub trait ReviewRepositoryContract: Send + Sync {
    fn next(&self) -> Result<Option<ReviewCard>>;
    fn complete(&self, card_id: &str, rating: u8) -> Result<ReviewCard>;
    fn skip(&self, card_id: &str) -> Result<()>;
    fn statistics(&self) -> Result<String>;
}
