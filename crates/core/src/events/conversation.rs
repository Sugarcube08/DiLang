//! Conversation Event Taxonomies

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ConversationEventPayload {
    ConversationStarted { scenario_id: String },
    ConversationEnded { conversation_id: String },
    MessageReceived { conversation_id: String, sender: String, text: String },
    MessageGenerated { conversation_id: String, text: String },
    CorrectionGenerated { conversation_id: String, original_text: String, corrected_text: String, explanation: String },
}
