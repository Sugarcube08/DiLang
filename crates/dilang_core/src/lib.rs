//! DiLang Core Engine Library
//! 
//! Single Source of Truth for deterministic learning algorithms, local AI model orchestrators,
//! SQLite storage access, and FSRS spaced repetition scheduling.

pub mod bridge;
pub mod engine;
pub mod error;

pub use error::DiLangError;

/// Initialize DiLang Core system state
pub fn init_core() -> Result<(), DiLangError> {
    tracing::info!("Initializing DiLang Core Native Engine");
    Ok(())
}
