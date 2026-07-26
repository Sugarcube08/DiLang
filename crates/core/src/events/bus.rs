//! Thread-Safe In-Memory Event Bus Implementation

use std::sync::Arc;
use tokio::sync::broadcast;
use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use uuid::Uuid;

/// Immutable Standard Header for all Application Events
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EventHeader {
    pub id: String,
    pub timestamp: DateTime<Utc>,
    pub session_id: String,
    pub user_id: String,
    pub source: String,
    pub version: u32,
}

impl EventHeader {
    pub fn new(source: &str) -> Self {
        Self {
            id: Uuid::new_v4().to_string(),
            timestamp: Utc::now(),
            session_id: "default-session".to_string(),
            user_id: "local-user".to_string(),
            source: source.to_string(),
            version: 1,
        }
    }
}

/// Generic Wrapper for System Events
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SystemEvent<T> {
    pub header: EventHeader,
    pub payload: T,
}

/// Thread-safe EventBus broadcasting events across workers and repositories
#[derive(Clone)]
pub struct EventBus {
    sender: broadcast::Sender::<(String, String)>, // (event_type, json_payload)
}

impl EventBus {
    pub fn new(capacity: usize) -> Self {
        let (sender, _) = broadcast::channel(capacity);
        Self { sender }
    }

    pub fn publish<T: Serialize>(&self, event_type: &str, payload: &T) -> anyhow::Result<usize> {
        let json_payload = serde_json::to_string(payload)?;
        let count = self.sender.send((event_type.to_string(), json_payload))?;
        Ok(count)
    }

    pub fn subscribe(&self) -> broadcast::Receiver::<(String, String)> {
        self.sender.subscribe()
    }
}

static GLOBAL_EVENT_BUS: once_cell::sync::Lazy<Arc<EventBus>> = 
    once_cell::sync::Lazy::new(|| Arc::new(EventBus::new(1024)));

pub fn global_event_bus() -> Arc<EventBus> {
    GLOBAL_EVENT_BUS.clone()
}
