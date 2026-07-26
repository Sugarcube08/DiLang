//! Vocabulary Repository Contract

use anyhow::Result;
use crate::models::Vocabulary;

pub trait VocabularyRepositoryContract: Send + Sync {
    fn lookup(&self, term: &str) -> Result<Option<Vocabulary>>;
    fn search(&self, query: &str) -> Result<Vec<Vocabulary>>;
    fn mastered(&self) -> Result<Vec<Vocabulary>>;
    fn weak(&self) -> Result<Vec<Vocabulary>>;
    fn update(&self, vocab: &Vocabulary) -> Result<()>;
}
