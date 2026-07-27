//! Capability Registry System
//! Decouples application capability queries (e.g. Conversation, STT, TTS) from concrete model runtimes.

use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::sync::Mutex;

#[derive(Debug, Clone, Hash, Eq, PartialEq, Serialize, Deserialize)]
pub enum Capability {
    Conversation,
    SpeechToText,
    TextToSpeech,
    VectorEmbeddings,
    SpacedRepetition,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProviderDescriptor {
    pub provider_id: String,
    pub name: String,
    pub is_available: bool,
}

pub struct CapabilityRegistry {
    providers: Mutex<HashMap<Capability, ProviderDescriptor>>,
}

impl Default for CapabilityRegistry {
    fn default() -> Self {
        Self::new()
    }
}

impl CapabilityRegistry {
    pub fn new() -> Self {
        let mut map = HashMap::new();
        map.insert(
            Capability::Conversation,
            ProviderDescriptor {
                provider_id: "qwen-llama-cpp".to_string(),
                name: "Qwen3-0.6B Instruct (llama.cpp)".to_string(),
                is_available: true,
            },
        );
        map.insert(
            Capability::SpeechToText,
            ProviderDescriptor {
                provider_id: "whisper-cpp".to_string(),
                name: "Whisper.cpp".to_string(),
                is_available: true,
            },
        );
        map.insert(
            Capability::TextToSpeech,
            ProviderDescriptor {
                provider_id: "piper-onnx".to_string(),
                name: "Piper ONNX".to_string(),
                is_available: true,
            },
        );
        Self {
            providers: Mutex::new(map),
        }
    }

    pub fn get_provider(&self, cap: Capability) -> Option<ProviderDescriptor> {
        let guard = self.providers.lock().unwrap();
        guard.get(&cap).cloned()
    }
}
