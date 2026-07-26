//! System & Runtime Lifecycle Event Taxonomies

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum SystemEventPayload {
    AppStarted {
        timestamp: String,
    },
    AppStopped {
        timestamp: String,
    },
    SettingsChanged {
        key: String,
        value: String,
    },
    LanguageChanged {
        new_language: String,
    },
    ProviderLoaded {
        provider_name: String,
    },
    ProviderFailed {
        provider_name: String,
        error: String,
    },
}
