//! Structured Logging Formatter

use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StructuredLogEntry {
    pub timestamp: DateTime<Utc>,
    pub session_id: String,
    pub module: String,
    pub operation: String,
    pub duration_ms: u64,
    pub result: String,
    pub thread_id: String,
}

pub fn emit_structured_log(module: &str, operation: &str, duration_ms: u64, result: &str) {
    let entry = StructuredLogEntry {
        timestamp: Utc::now(),
        session_id: "main-session".to_string(),
        module: module.to_string(),
        operation: operation.to_string(),
        duration_ms,
        result: result.to_string(),
        thread_id: format!("{:?}", std::thread::current().id()),
    };
    tracing::info!(target: "structured_log", "{}", serde_json::to_string(&entry).unwrap_or_default());
}
