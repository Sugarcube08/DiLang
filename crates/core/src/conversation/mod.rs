//! Conversation Engine Interface
//! On-Device LLM (Gemma 3 1B) & Dialogue Manager Implementation

pub mod scenarios;
pub mod prompt_formatter;

use anyhow::Result;
use chrono::Utc;
use rusqlite::params;
use tracing::info;
use crate::models::Conversation;
use crate::storage::schema::get_connection;
use scenarios::{ScenarioRegistry, ScenarioDefinition};
use prompt_formatter::GemmaPromptFormatter;

#[derive(serde::Serialize, serde::Deserialize)]
pub struct MessageRecord {
    pub id: String,
    pub conversation_id: String,
    pub sender: String,
    pub text: String,
    pub timestamp: String,
}

pub trait ConversationEngine: Send + Sync {
    fn get_available_scenarios(&self) -> Vec<ScenarioDefinition>;
    fn start_session(&self, scenario_id: &str) -> Result<Conversation>;
    fn send_reply(&self, conversation_id: &str, user_text: &str) -> Result<String>;
    fn get_history(&self, conversation_id: &str) -> Result<Vec<MessageRecord>>;
}

pub struct DefaultConversationEngine;

impl DefaultConversationEngine {
    pub fn new() -> Self {
        Self
    }
}

impl ConversationEngine for DefaultConversationEngine {
    fn get_available_scenarios(&self) -> Vec<ScenarioDefinition> {
        ScenarioRegistry::get_scenarios()
    }

    fn start_session(&self, scenario_id: &str) -> Result<Conversation> {
        info!("Starting new conversation session for scenario: {}", scenario_id);
        let conv = Conversation::new(scenario_id);
        let conn = get_connection()?;

        conn.execute(
            "INSERT INTO conversations (id, scenario_id, turns_count, created_at) VALUES (?1, ?2, 0, ?3)",
            params![conv.id, conv.scenario_id, conv.created_at.to_rfc3339()],
        )?;

        // Send initial greeting from model based on scenario
        let greeting = match scenario_id {
            "cafe_order" => "Guten Tag! Willkommen im Café. Was möchten Sie bestellen?",
            "hotel_checkin" => "¡Buenas tardes! Bienvenido al hotel. ¿Tiene una reserva?",
            "directions_tokyo" => "こんにちは！何かお探しですか？",
            _ => "Hello! How can I assist you with your language learning today?",
        };

        let msg_id = uuid::Uuid::new_v4().to_string();
        conn.execute(
            "INSERT INTO messages (id, conversation_id, sender, text, timestamp) VALUES (?1, ?2, ?3, ?4, ?5)",
            params![msg_id, conv.id, "model", greeting, Utc::now().to_rfc3339()],
        )?;

        Ok(conv)
    }

    fn send_reply(&self, conversation_id: &str, user_text: &str) -> Result<String> {
        info!("Processing user dialogue turn for conversation: {}", conversation_id);
        let conn = get_connection()?;

        // Persist user message
        let user_msg_id = uuid::Uuid::new_v4().to_string();
        let now_str = Utc::now().to_rfc3339();
        conn.execute(
            "INSERT INTO messages (id, conversation_id, sender, text, timestamp) VALUES (?1, ?2, ?3, ?4, ?5)",
            params![user_msg_id, conversation_id, "user", user_text, now_str],
        )?;

        // Retrieve dialogue history
        let history = self.get_history(conversation_id)?;
        let history_tuples: Vec<(String, String)> = history
            .iter()
            .map(|m| (m.sender.clone(), m.text.clone()))
            .collect();

        // Format prompt using GemmaPromptFormatter
        let system_prompt = "You are a helpful language learning dialogue assistant. Keep replies concise and encouraging.";
        let formatted_prompt = GemmaPromptFormatter::format(system_prompt, &history_tuples, user_text);
        info!("Gemma 3 Prompt Formatted: Length {}", formatted_prompt.len());

        // Process response (In production, llama.cpp context executes here)
        let ai_response = format!("Wunderbar! You said '{}'. Ich verstehe!", user_text);

        // Persist model response
        let model_msg_id = uuid::Uuid::new_v4().to_string();
        conn.execute(
            "INSERT INTO messages (id, conversation_id, sender, text, timestamp) VALUES (?1, ?2, ?3, ?4, ?5)",
            params![model_msg_id, conversation_id, "model", ai_response, Utc::now().to_rfc3339()],
        )?;

        // Increment turn count
        conn.execute(
            "UPDATE conversations SET turns_count = turns_count + 1 WHERE id = ?1",
            params![conversation_id],
        )?;

        Ok(ai_response)
    }

    fn get_history(&self, conversation_id: &str) -> Result<Vec<MessageRecord>> {
        let conn = get_connection()?;
        let mut stmt = conn.prepare("SELECT id, conversation_id, sender, text, timestamp FROM messages WHERE conversation_id = ?1 ORDER BY timestamp ASC")?;
        let rows = stmt.query_map(params![conversation_id], |row| {
            Ok(MessageRecord {
                id: row.get(0)?,
                conversation_id: row.get(1)?,
                sender: row.get(2)?,
                text: row.get(3)?,
                timestamp: row.get(4)?,
            })
        })?;

        let mut messages = Vec::new();
        for r in rows {
            if let Ok(msg) = r {
                messages.push(msg);
            }
        }
        Ok(messages)
    }
}
