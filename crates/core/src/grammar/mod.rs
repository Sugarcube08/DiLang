//! Grammar Parsing & AST Evaluation Interface

use anyhow::Result;
use crate::models::GrammarConcept;

pub trait GrammarEngine: Send + Sync {
    fn evaluate_syntax(&self, text: &str) -> Result<Vec<GrammarConcept>>;
}
