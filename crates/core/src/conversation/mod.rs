//! Conversation Engine Interface
//! On-Device LLM (Gemma 3 1B) & Dialogue Manager Trait Specifications

use anyhow::Result;
use crate::models::Conversation;

pub trait ConversationEngine: Send + Sync {
    fn start_session(&self, scenario_id: &str) -> Result<Conversation>;
    fn send_reply(&self, conversation_id: &str, user_text: &str) -> Result<String>;
}

pub struct DefaultConversationEngine;

impl ConversationEngine for DefaultConversationEngine {
    fn start_session(&self, scenario_id: &str) -> Result<Conversation> {
        Ok(Conversation::new(scenario_id))
    }

    fn send_reply(&self, _conversation_id: &str, user_text: &str) -> Result<String> {
        Ok(format!("Echoing: {}", user_text))
    }
}
