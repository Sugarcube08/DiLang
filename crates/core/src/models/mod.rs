//! DiLang Domain Models (Frozen Data Structures)
//!
//! Immutable single source of truth for application domain entities.

use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// User Profile
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: String,
    pub username: String,
    pub native_language: String,
    pub target_language: String,
    pub created_at: DateTime<Utc>,
}

impl User {
    pub fn new(username: &str, native_lang: &str, target_lang: &str) -> Self {
        Self {
            id: Uuid::new_v4().to_string(),
            username: username.to_string(),
            native_language: native_lang.to_string(),
            target_language: target_lang.to_string(),
            created_at: Utc::now(),
        }
    }
}

/// Target Language Specification
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Language {
    pub code: String,
    pub name: String,
    pub script: String,
    pub default_voice_id: String,
}

/// Vocabulary Entry & Mastery State
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Vocabulary {
    pub id: String,
    pub term: String,
    pub lemma: String,
    pub pos: String,        // Part of Speech
    pub cefr_level: String, // A1, A2, B1, B2, C1, C2
    pub definition: String,
    pub example_sentence: String,
}

/// Grammar Concept & CEFR Syntax Node
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GrammarConcept {
    pub id: String,
    pub title: String,
    pub cefr_level: String,
    pub rule_pattern: String,
    pub explanation: String,
}

/// Active Roleplay Conversation Session
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Conversation {
    pub id: String,
    pub scenario_id: String,
    pub turns_count: u32,
    pub created_at: DateTime<Utc>,
}

impl Conversation {
    pub fn new(scenario_id: &str) -> Self {
        Self {
            id: Uuid::new_v4().to_string(),
            scenario_id: scenario_id.to_string(),
            turns_count: 0,
            created_at: Utc::now(),
        }
    }
}

/// FSRS v4 Review Flashcard State
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ReviewCard {
    pub id: String,
    pub vocab_id: String,
    pub stability: f64,  // FSRS Memory Stability (S)
    pub difficulty: f64, // FSRS Difficulty (D)
    pub reps: u32,
    pub lapses: u32,
    pub due_at: DateTime<Utc>,
    pub last_review_at: Option<DateTime<Utc>>,
}

/// Learning Session Analytics Record
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearningSession {
    pub id: String,
    pub user_id: String,
    pub duration_seconds: u32,
    pub cards_reviewed: u32,
    pub dialogue_turns: u32,
    pub timestamp: DateTime<Utc>,
}

/// Speech-to-Text Pronunciation Score
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PronunciationResult {
    pub text: String,
    pub fluency_score: f32, // 0.0 - 100.0
    pub accuracy_score: f32,
    pub phoneme_errors: Vec<String>,
}

/// User Daily Learning Goal
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LearningGoal {
    pub target_daily_minutes: u32,
    pub target_daily_cards: u32,
    pub current_streak_days: u32,
}

/// Analytics Progress Snapshot
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProgressSnapshot {
    pub total_known_words: u32,
    pub total_mastered_grammar: u32,
    pub total_conversations: u32,
    pub total_reviews_due: u32,
    pub total_practice_hours: f32,
    pub average_retention_rate: f32,
}

/// Application Settings
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Settings {
    pub theme_mode: String,
    pub is_offline_mode: bool,
    pub model_quantization: String,
    pub auto_play_audio: bool,
}

impl Default for Settings {
    fn default() -> Self {
        Self {
            theme_mode: "dark".to_string(),
            is_offline_mode: true,
            model_quantization: "Q4_K_M".to_string(),
            auto_play_audio: true,
        }
    }
}
