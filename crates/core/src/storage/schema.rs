//! SQLite DDL Schema Definitions & Operational Migrations

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

-- User Profiles Table
CREATE TABLE IF NOT EXISTS user_profiles (
    user_id TEXT PRIMARY KEY,
    avatar TEXT NOT NULL DEFAULT 'default_avatar.svg',
    age INTEGER,
    country TEXT NOT NULL DEFAULT 'US',
    timezone TEXT NOT NULL DEFAULT 'UTC',
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Languages Table
CREATE TABLE IF NOT EXISTS languages (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    script TEXT NOT NULL,
    default_voice_id TEXT NOT NULL
);

-- Installed Models Operational Table
CREATE TABLE IF NOT EXISTS installed_models (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    version TEXT NOT NULL,
    path TEXT NOT NULL,
    sha256 TEXT NOT NULL,
    size_bytes INTEGER NOT NULL,
    installed_at TEXT NOT NULL
);

-- Download Jobs Operational Table
CREATE TABLE IF NOT EXISTS download_jobs (
    id TEXT PRIMARY KEY,
    model_name TEXT NOT NULL,
    url TEXT NOT NULL,
    bytes_downloaded INTEGER NOT NULL DEFAULT 0,
    total_bytes INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'queued',
    updated_at TEXT NOT NULL
);

-- Model Versions Compatibility Table
CREATE TABLE IF NOT EXISTS model_versions (
    model_name TEXT PRIMARY KEY,
    version TEXT NOT NULL,
    min_app_version TEXT NOT NULL
);

-- Language Resources Table
CREATE TABLE IF NOT EXISTS language_resources (
    id TEXT PRIMARY KEY,
    code TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    path TEXT NOT NULL,
    FOREIGN KEY(code) REFERENCES languages(code) ON DELETE CASCADE
);

-- Learning Goals Table
CREATE TABLE IF NOT EXISTS learning_goals (
    user_id TEXT PRIMARY KEY,
    target_daily_minutes INTEGER NOT NULL DEFAULT 15,
    target_daily_cards INTEGER NOT NULL DEFAULT 20,
    current_streak_days INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
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
CREATE INDEX IF NOT EXISTS idx_installed_models_name ON installed_models(name);
"#;

pub fn initialize_schema() -> Result<()> {
    info!("Initializing SQLite database schema version {}", CURRENT_SCHEMA_VERSION);
    let conn = get_connection()?;
    conn.execute_batch(DDL_SCHEMA_V1)?;
    info!("Database Schema Migration Applied Successfully");
    Ok(())
}

pub fn get_connection() -> Result<Connection> {
    if let Some(path) = crate::get_db_path() {
        if let Some(parent) = path.parent() {
            std::fs::create_dir_all(parent)?;
        }
        Ok(Connection::open(path)?)
    } else {
        Ok(Connection::open_in_memory()?)
    }
}
