//! Core Repository Interfaces & Transactional Memory-Caching Rules

pub mod conversation;
pub mod vocabulary;
pub mod grammar;
pub mod review;
pub mod analytics;
pub mod settings;

pub use conversation::{ConversationRepositoryContract, ConversationRepositoryImpl};
pub use vocabulary::VocabularyRepositoryContract;
pub use grammar::GrammarRepositoryContract;
pub use review::ReviewRepositoryContract;
pub use analytics::AnalyticsRepositoryContract;
pub use settings::SettingsRepositoryContract;
