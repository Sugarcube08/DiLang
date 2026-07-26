//! Grammar Repository Contract

use crate::models::GrammarConcept;
use anyhow::Result;

pub trait GrammarRepositoryContract: Send + Sync {
    fn concepts(&self) -> Result<Vec<GrammarConcept>>;
    fn mastery(&self) -> Result<f32>;
    fn mistakes(&self) -> Result<Vec<String>>;
    fn review(&self, concept_id: &str) -> Result<()>;
}
