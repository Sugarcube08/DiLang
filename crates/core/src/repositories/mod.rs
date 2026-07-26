//! Core Repository Interfaces & Transactional Memory-Caching Rules

pub mod analytics;
pub mod conversation;
pub mod grammar;
pub mod review;
pub mod settings;
pub mod user;
pub mod vocabulary;

pub use analytics::AnalyticsRepositoryContract;
pub use conversation::{ConversationRepositoryContract, ConversationRepositoryImpl};
pub use grammar::GrammarRepositoryContract;
pub use review::ReviewRepositoryContract;
pub use settings::{SettingsRepositoryContract, SettingsRepositoryImpl};
pub use user::{UserRepositoryContract, UserRepositoryImpl};
pub use vocabulary::VocabularyRepositoryContract;
