//! Vocabulary Subsystem Interface

use anyhow::Result;
use crate::models::Vocabulary;

pub trait VocabularyEngine: Send + Sync {
    fn lookup(&self, word: &str, target_lang: &str) -> Result<Option<Vocabulary>>;
    fn extract_terms(&self, text: &str) -> Result<Vec<Vocabulary>>;
}
