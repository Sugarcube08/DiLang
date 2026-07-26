//! Centralized AppError Hierarchy & Classification

use thiserror::Error;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ErrorSeverity {
    Info,
    Warning,
    Error,
    Fatal,
}

#[derive(Error, Debug, Clone, Serialize, Deserialize)]
pub enum AppError {
    #[error("Storage Error [{code}]: {user_message}")]
    StorageError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },

    #[error("Conversation Error [{code}]: {user_message}")]
    ConversationError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },

    #[error("Review Error [{code}]: {user_message}")]
    ReviewError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },

    #[error("Sync Error [{code}]: {user_message}")]
    SyncError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },

    #[error("AI Error [{code}]: {user_message}")]
    AIError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },

    #[error("Provider Error [{code}]: {user_message}")]
    ProviderError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },

    #[error("Config Error [{code}]: {user_message}")]
    ConfigError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },

    #[error("Internal Error [{code}]: {user_message}")]
    InternalError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
}

impl AppError {
    pub fn internal(msg: &str) -> Self {
        AppError::InternalError {
            code: 5000,
            severity: ErrorSeverity::Error,
            is_recoverable: true,
            user_message: "An internal system error occurred.".to_string(),
            dev_context: msg.to_string(),
        }
    }

    pub fn config(msg: &str) -> Self {
        AppError::ConfigError {
            code: 4000,
            severity: ErrorSeverity::Warning,
            is_recoverable: true,
            user_message: "Configuration error detected.".to_string(),
            dev_context: msg.to_string(),
        }
    }
}
