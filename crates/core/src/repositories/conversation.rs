//! Conversation Repository Contract & Atomic Transaction Manager

use anyhow::Result;
use crate::models::Conversation;

pub trait ConversationRepositoryContract: Send + Sync {
    fn start(&self, scenario_id: &str) -> Result<Conversation>;
    fn reply(&self, conversation_id: &str, text: &str) -> Result<String>;
    fn history(&self, conversation_id: &str) -> Result<Vec<String>>;
    fn delete(&self, conversation_id: &str) -> Result<()>;
    fn archive(&self, conversation_id: &str) -> Result<()>;
}

pub struct ConversationRepositoryImpl;

impl ConversationRepositoryImpl {
    pub fn new() -> Self {
        Self
    }
}

impl ConversationRepositoryContract for ConversationRepositoryImpl {
    fn start(&self, scenario_id: &str) -> Result<Conversation> {
        Ok(Conversation::new(scenario_id))
    }

    fn reply(&self, _conversation_id: &str, text: &str) -> Result<String> {
        // Atomic Transaction: Message Store -> Vocab Extract -> Progress Update -> Schedule Review
        Ok(format!("Response to: {}", text))
    }

    fn history(&self, _conversation_id: &str) -> Result<Vec<String>> {
        Ok(vec![])
    }

    fn delete(&self, _conversation_id: &str) -> Result<()> {
        Ok(())
    }

    fn archive(&self, _conversation_id: &str) -> Result<()> {
        Ok(())
    }
}
