//! Vocabulary Subsystem & Extraction Engine

use anyhow::Result;
use rusqlite::params;
use tracing::info;
use crate::models::Vocabulary;
use crate::analysis::AnalyzedSentence;
use crate::storage::schema::get_connection;
use crate::events::{global_event_bus, VocabularyEventPayload};

pub trait VocabularyEngine: Send + Sync {
    fn lookup(&self, word: &str, target_lang: &str) -> Result<Option<Vocabulary>>;
    fn extract_and_persist(&self, sentence: &AnalyzedSentence) -> Result<Vec<Vocabulary>>;
}

pub struct DefaultVocabularyEngine;

impl DefaultVocabularyEngine {
    pub fn new() -> Self {
        Self
    }
}

impl VocabularyEngine for DefaultVocabularyEngine {
    fn lookup(&self, word: &str, _target_lang: &str) -> Result<Option<Vocabulary>> {
        let conn = get_connection()?;
        let mut stmt = conn.prepare("SELECT id, term, lemma, pos, cefr_level, definition, example_sentence FROM vocabulary WHERE lemma = ?1 OR term = ?1 LIMIT 1")?;
        let result = stmt.query_row(params![word.to_lowercase()], |row| {
            Ok(Vocabulary {
                id: row.get(0)?,
                term: row.get(1)?,
                lemma: row.get(2)?,
                pos: row.get(3)?,
                cefr_level: row.get(4)?,
                definition: row.get(5)?,
                example_sentence: row.get(6)?,
            })
        });

        match result {
            Ok(vocab) => Ok(Some(vocab)),
            Err(rusqlite::Error::QueryReturnedNoRows) => Ok(None),
            Err(e) => Err(e.into()),
        }
    }

    fn extract_and_persist(&self, sentence: &AnalyzedSentence) -> Result<Vec<Vocabulary>> {
        info!("Extracting and persisting vocabulary tokens from sentence...");
        let conn = get_connection()?;
        let bus = global_event_bus();
        let mut extracted = Vec::new();

        for token in &sentence.tokens {
            let vocab_id = format!("v-{}", uuid::Uuid::new_v4().to_string()[..8].to_string());
            let def = format!("Definition for {}", token.lemma);

            conn.execute(
                r#"INSERT OR IGNORE INTO vocabulary (id, term, lemma, pos, cefr_level, definition, example_sentence)
                   VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)"#,
                params![
                    vocab_id,
                    token.token,
                    token.lemma,
                    token.pos,
                    token.cefr_level,
                    def,
                    sentence.raw_text
                ],
            )?;

            let vocab = Vocabulary {
                id: vocab_id,
                term: token.token.clone(),
                lemma: token.lemma.clone(),
                pos: token.pos.clone(),
                cefr_level: token.cefr_level.clone(),
                definition: def,
                example_sentence: sentence.raw_text.clone(),
            };

            // Publish event to EventBus
            let payload = VocabularyEventPayload::VocabularyDetected {
                term: token.token.clone(),
                cefr_level: token.cefr_level.clone(),
            };
            let _ = bus.publish("vocabulary", &payload);

            extracted.push(vocab);
        }

        Ok(extracted)
    }
}
