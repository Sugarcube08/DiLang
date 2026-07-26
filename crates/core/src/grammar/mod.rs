//! Grammar Engine Implementation

use crate::analysis::AnalyzedSentence;
use crate::events::{global_event_bus, GrammarEventPayload};
use crate::models::GrammarConcept;
use crate::storage::schema::get_connection;
use anyhow::Result;
use rusqlite::params;
use tracing::info;

pub trait GrammarEngine: Send + Sync {
    fn extract_and_persist(&self, sentence: &AnalyzedSentence) -> Result<Vec<GrammarConcept>>;
}

#[derive(Default)]
pub struct DefaultGrammarEngine;

impl DefaultGrammarEngine {
    pub fn new() -> Self {
        Self
    }
}

impl GrammarEngine for DefaultGrammarEngine {
    fn extract_and_persist(&self, sentence: &AnalyzedSentence) -> Result<Vec<GrammarConcept>> {
        info!("Extracting grammar concepts from sentence...");
        let conn = get_connection()?;
        let bus = global_event_bus();
        let mut concepts = Vec::new();

        for rule in &sentence.grammar_rules {
            let concept_id = format!("g-{}", &uuid::Uuid::new_v4().to_string()[..8]);
            let explanation = format!("Grammar rule: {}", rule);

            conn.execute(
                r#"INSERT OR IGNORE INTO grammar_concepts (id, title, cefr_level, rule_pattern, explanation)
                   VALUES (?1, ?2, ?3, ?4, ?5)"#,
                params![concept_id, rule, "A1", rule, explanation],
            )?;

            let concept = GrammarConcept {
                id: concept_id,
                title: rule.clone(),
                cefr_level: "A1".to_string(),
                rule_pattern: rule.clone(),
                explanation,
            };

            let payload = GrammarEventPayload::GrammarDetected {
                rule_pattern: rule.clone(),
            };
            let _ = bus.publish("grammar", &payload);

            concepts.push(concept);
        }

        Ok(concepts)
    }
}
