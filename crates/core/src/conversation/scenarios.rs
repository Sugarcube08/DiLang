//! Dialogue Scenarios & System Prompts

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScenarioDefinition {
    pub id: String,
    pub title: String,
    pub description: String,
    pub target_language: String,
    pub cefr_level: String,
    pub system_prompt: String,
}

pub struct ScenarioRegistry;

impl ScenarioRegistry {
    pub fn get_scenarios() -> Vec<ScenarioDefinition> {
        vec![
            ScenarioDefinition {
                id: "cafe_order".to_string(),
                title: "Ordering Coffee in Berlin".to_string(),
                description: "Practice ordering coffee and pastries in German at a busy café.".to_string(),
                target_language: "German".to_string(),
                cefr_level: "A1".to_string(),
                system_prompt: "You are a friendly German barista at a café in Berlin. Reply in simple German suitable for an A1 learner. Keep responses under 2 sentences.".to_string(),
            },
            ScenarioDefinition {
                id: "hotel_checkin".to_string(),
                title: "Hotel Check-in in Madrid".to_string(),
                description: "Check into your hotel room and request extra towels in Spanish.".to_string(),
                target_language: "Spanish".to_string(),
                cefr_level: "A2".to_string(),
                system_prompt: "You are a polite hotel receptionist in Madrid. Speak clear, simple Spanish at A2 CEFR level.".to_string(),
            },
            ScenarioDefinition {
                id: "directions_tokyo".to_string(),
                title: "Asking Directions in Tokyo".to_string(),
                description: "Ask a local for directions to Shibuya station in Japanese.".to_string(),
                target_language: "Japanese".to_string(),
                cefr_level: "N5".to_string(),
                system_prompt: "You are a helpful Tokyo resident. Assist the user with simple Japanese directions.".to_string(),
            },
        ]
    }
}
