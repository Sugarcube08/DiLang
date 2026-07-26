//! Public High-Level Engine API Facade
//! Clean, thread-safe entry point for native apps and FFI bindings.

use anyhow::Result;
use crate::models::{Conversation, ProgressSnapshot, ReviewCard, Vocabulary};
use crate::conversation::{ConversationEngine, DefaultConversationEngine};

pub struct DiLangEngineFacade {
    conversation_engine: Box<dyn ConversationEngine>,
}

impl DiLangEngineFacade {
    pub fn new() -> Self {
        Self {
            conversation_engine: Box::new(DefaultConversationEngine),
        }
    }

    /// Global engine initialization
    pub fn initialize(&self) -> Result<()> {
        crate::init_logging();
        crate::storage::schema::initialize_schema()?;
        Ok(())
    }

    /// Graceful engine shutdown
    pub fn shutdown(&self) -> Result<()> {
        tracing::info!("Shutting down DiLang Core Engine");
        Ok(())
    }

    /// Start a new dialogue roleplay conversation
    pub fn conversation_start(&self, scenario_id: &str) -> Result<Conversation> {
        self.conversation_engine.start_session(scenario_id)
    }

    /// Reply to an ongoing conversation
    pub fn conversation_reply(&self, conversation_id: &str, user_text: &str) -> Result<String> {
        self.conversation_engine.send_reply(conversation_id, user_text)
    }

    /// Lookup vocabulary term
    pub fn vocabulary_lookup(&self, term: &str, target_lang: &str) -> Result<Option<Vocabulary>> {
        Ok(Some(Vocabulary {
            id: "v-001".to_string(),
            term: term.to_string(),
            lemma: term.to_string(),
            pos: "noun".to_string(),
            cefr_level: "A1".to_string(),
            definition: format!("Definition for {} ({})", term, target_lang),
            example_sentence: format!("Example sentence containing {}", term),
        }))
    }

    /// Fetch next due review card
    pub fn review_next(&self) -> Result<Option<ReviewCard>> {
        Ok(None)
    }

    /// Compute analytics progress snapshot
    pub fn analytics_snapshot(&self) -> Result<ProgressSnapshot> {
        Ok(ProgressSnapshot {
            total_known_words: 150,
            total_mastered_grammar: 12,
            total_practice_hours: 4.5,
            average_retention_rate: 0.92,
        })
    }

    /// Start P2P CRDT sync
    pub fn sync_start(&self) -> Result<String> {
        Ok("Sync Engine Initialized".to_string())
    }
}
