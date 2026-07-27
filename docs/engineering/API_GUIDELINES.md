# DiLang API Guidelines & Bridge Protocols

## 1. Overview

Communication between the Flutter Dart frontend and the Rust Core backend is conducted over generated `flutter_rust_bridge` (FRB v2) asynchronous channels.

---

## 2. API Contract Principles

1. **Opaque Pointers for Engine Instances**: Large native state structures (such as loaded Qwen3-0.6B model weights or SQLite handle pools) are passed to Dart as opaque thread-safe Rust references (`Arc<RwLock<T>>`).
2. **Stream-based Async Outputs**: Operations producing continuous data tokens (speech audio playback chunks, streaming LLM response tokens) MUST utilize `StreamSink<T>` parameters.
3. **Structured Enums for Statuses**: Complex return states must use Rust enums converted to Dart sealed classes.

---

## 3. Rust Bridge Function Signature Standards

```rust
// Exposed API module in dilang_core/src/api/conversation.rs

use flutter_rust_bridge::frb;

pub struct BridgeScenarioSession {
    inner: std::sync::Arc<tokio::sync::RwLock<crate::conversation::ScenarioSession>>,
}

impl BridgeScenarioSession {
    #[frb(sync)]
    pub fn new(scenario_id: String) -> Result<Self, BridgeError> {
        // Synchronous light initialization
    }

    pub async fn process_user_audio(
        &self,
        audio_samples: Vec<f32>,
        sample_rate: u32,
        token_sink: StreamSink<String>,
    ) -> Result<BridgeTurnSummary, BridgeError> {
        // Asynchronous processing & token streaming
    }
}
```

---

## 4. Error Handling across FRB Boundary

Rust error types must implement `Into<frb::AnyhowException>` or map to a unified `BridgeError` enum exposed to Dart:

```rust
#[derive(Debug, thiserror::Error)]
pub enum BridgeError {
    #[error("Local AI model not initialized: {0}")]
    ModelNotLoaded(String),
    #[error("Audio input buffer corrupt")]
    AudioCorruption,
    #[error("Database query failed: {0}")]
    DatabaseError(String),
}
```
