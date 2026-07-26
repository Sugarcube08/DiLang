//! SQLite DDL Schema Definitions & Migrations

use anyhow::Result;
use rusqlite::Connection;
use tracing::info;

pub const CURRENT_SCHEMA_VERSION: u32 = 1;

pub const DDL_SCHEMA_V1: &str = r#"
-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL,
    native_language TEXT NOT NULL,
    target_language TEXT NOT NULL,
    created_at TEXT NOT NULL
);

-- Languages Table
CREATE TABLE IF NOT EXISTS languages (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    script TEXT NOT NULL,
    default_voice_id TEXT NOT NULL
);

-- Vocabulary Table
CREATE TABLE IF NOT EXISTS vocabulary (
    id TEXT PRIMARY KEY,
    term TEXT NOT NULL,
    lemma TEXT NOT NULL,
    pos TEXT NOT NULL,
    cefr_level TEXT NOT NULL,
    definition TEXT NOT NULL,
    example_sentence TEXT NOT NULL
);

-- Grammar Concepts Table
CREATE TABLE IF NOT EXISTS grammar_concepts (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    cefr_level TEXT NOT NULL,
    rule_pattern TEXT NOT NULL,
    explanation TEXT NOT NULL
);

-- Conversations Table
CREATE TABLE IF NOT EXISTS conversations (
    id TEXT PRIMARY KEY,
    scenario_id TEXT NOT NULL,
    turns_count INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
);

-- Messages Table
CREATE TABLE IF NOT EXISTS messages (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    sender TEXT NOT NULL,
    text TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    FOREIGN KEY(conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);

-- FSRS Review Cards Table
CREATE TABLE IF NOT EXISTS review_cards (
    id TEXT PRIMARY KEY,
    vocab_id TEXT NOT NULL,
    stability REAL NOT NULL DEFAULT 1.0,
    difficulty REAL NOT NULL DEFAULT 5.0,
    reps INTEGER NOT NULL DEFAULT 0,
    lapses INTEGER NOT NULL DEFAULT 0,
    due_at TEXT NOT NULL,
    last_review_at TEXT,
    FOREIGN KEY(vocab_id) REFERENCES vocabulary(id) ON DELETE CASCADE
);

-- Learning Sessions Table
CREATE TABLE IF NOT EXISTS learning_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    duration_seconds INTEGER NOT NULL,
    cards_reviewed INTEGER NOT NULL,
    dialogue_turns INTEGER NOT NULL,
    timestamp TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Application Settings Table
CREATE TABLE IF NOT EXISTS settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

-- Indexes for Fast Query Performance
CREATE INDEX IF NOT EXISTS idx_vocabulary_term ON vocabulary(term);
CREATE INDEX IF NOT EXISTS idx_vocabulary_cefr ON vocabulary(cefr_level);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_review_cards_due ON review_cards(due_at);
"#;

pub fn initialize_schema() -> Result<()> {
    info!("Initializing SQLite database schema version {}", CURRENT_SCHEMA_VERSION);
    let conn = Connection::open_in_memory()?;
    conn.execute_batch(DDL_SCHEMA_V1)?;
    info!("Database Schema Migration Applied Successfully");
    Ok(())
}
