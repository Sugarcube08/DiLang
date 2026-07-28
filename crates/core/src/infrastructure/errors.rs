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
            AppError::StorageError {
                code, user_message, ..
            } => write!(f, "Storage Error [{}]: {}", code, user_message),
            AppError::ConversationError {
                code, user_message, ..
            } => write!(f, "Conversation Error [{}]: {}", code, user_message),
            AppError::ReviewError {
                code, user_message, ..
            } => write!(f, "Review Error [{}]: {}", code, user_message),
            AppError::SyncError {
                code, user_message, ..
            } => write!(f, "Sync Error [{}]: {}", code, user_message),
            AppError::AIError {
                code, user_message, ..
            } => write!(f, "AI Error [{}]: {}", code, user_message),
            AppError::ProviderError {
                code, user_message, ..
            } => write!(f, "Provider Error [{}]: {}", code, user_message),
            AppError::ConfigError {
                code, user_message, ..
            } => write!(f, "Config Error [{}]: {}", code, user_message),
            AppError::InternalError {
                code, user_message, ..
            } => write!(f, "Internal Error [{}]: {}", code, user_message),
        }
    }
}

impl std::error::Error for AppError {}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum PipelineStage {
    DownloadRequested,
    DownloadStarted,
    HttpConnecting,
    Downloading,
    DownloadFinished,
    VerificationStarted,
    ShaCalculation,
    ShaComparison,
    FileRename,
    SqliteRegistration,
    InstallationComplete,
    QueueAdvancement,
}

impl PipelineStage {
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::DownloadRequested => "DownloadRequested",
            Self::DownloadStarted => "DownloadStarted",
            Self::HttpConnecting => "HttpConnecting",
            Self::Downloading => "Downloading",
            Self::DownloadFinished => "DownloadFinished",
            Self::VerificationStarted => "VerificationStarted",
            Self::ShaCalculation => "ShaCalculation",
            Self::ShaComparison => "ShaComparison",
            Self::FileRename => "FileRename",
            Self::SqliteRegistration => "SqliteRegistration",
            Self::InstallationComplete => "InstallationComplete",
            Self::QueueAdvancement => "QueueAdvancement",
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum NetworkErrorKind {
    DnsFailure,
    TlsHandshakeFailure,
    RedirectLoop,
    Http403Forbidden,
    Http404NotFound,
    Http429RateLimited,
    HttpServerError,
    Timeout,
    ConnectionReset,
    InvalidUrl,
    Unknown,
}

impl NetworkErrorKind {
    pub fn classify(err: &reqwest::Error) -> Self {
        if err.is_timeout() {
            Self::Timeout
        } else if err.is_connect() {
            Self::DnsFailure
        } else if err.is_redirect() {
            Self::RedirectLoop
        } else if let Some(status) = err.status() {
            match status.as_u16() {
                403 => Self::Http403Forbidden,
                404 => Self::Http404NotFound,
                429 => Self::Http429RateLimited,
                500..=599 => Self::HttpServerError,
                _ => Self::Unknown,
            }
        } else {
            Self::Unknown
        }
    }
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

    pub fn pipeline_error(
        stage: PipelineStage,
        asset_id: &str,
        url: &str,
        error_msg: &str,
        retryable: bool,
    ) -> Self {
        AppError::InternalError {
            code: 5001,
            severity: ErrorSeverity::Error,
            is_recoverable: retryable,
            user_message: format!("Asset Pipeline Error [{:?}]: {}", stage, error_msg),
            dev_context: format!(
                "[PIPELINE ERROR] Stage={:?}, AssetID='{}', URL='{}', Retryable={}, Context={}",
                stage, asset_id, url, retryable, error_msg
            ),
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
