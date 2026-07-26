//! Centralized AppError Hierarchy & Classification

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ErrorSeverity {
    Info,
    Warning,
    Error,
    Fatal,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum AppError {
    StorageError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
    ConversationError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
    ReviewError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
    SyncError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
    AIError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
    ProviderError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
    ConfigError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
    InternalError {
        code: u32,
        severity: ErrorSeverity,
        is_recoverable: bool,
        user_message: String,
        dev_context: String,
    },
}

impl std::fmt::Display for AppError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            AppError::StorageError { code, user_message, .. } => write!(f, "Storage Error [{}]: {}", code, user_message),
            AppError::ConversationError { code, user_message, .. } => write!(f, "Conversation Error [{}]: {}", code, user_message),
            AppError::ReviewError { code, user_message, .. } => write!(f, "Review Error [{}]: {}", code, user_message),
            AppError::SyncError { code, user_message, .. } => write!(f, "Sync Error [{}]: {}", code, user_message),
            AppError::AIError { code, user_message, .. } => write!(f, "AI Error [{}]: {}", code, user_message),
            AppError::ProviderError { code, user_message, .. } => write!(f, "Provider Error [{}]: {}", code, user_message),
            AppError::ConfigError { code, user_message, .. } => write!(f, "Config Error [{}]: {}", code, user_message),
            AppError::InternalError { code, user_message, .. } => write!(f, "Internal Error [{}]: {}", code, user_message),
        }
    }
}

impl std::error::Error for AppError {}

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
