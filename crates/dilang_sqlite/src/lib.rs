//! DiLang SQLite Database Layer
//!
//! Encrypted local relational storage, FSRS review logs, conversation transcripts,
//! vector embeddings (sqlite-vec), and migrations. Direct access from Flutter is strictly PROHIBITED.

pub mod schema;
pub mod migrations;

pub struct DatabaseManager;

impl DatabaseManager {
    pub fn new() -> Self {
        Self
    }
}
