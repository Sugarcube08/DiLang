//! Public Engine API Facade Specification

use anyhow::Result;
use crate::models::{Conversation, ProgressSnapshot, ReviewCard, Vocabulary};
use crate::repositories::{ConversationRepositoryContract, ConversationRepositoryImpl};
use crate::lifecycle::AppLifecycleManager;
use crate::infrastructure::{CapabilityRegistry, Capability, MetricsCollector, InternalMetrics};

pub struct DiLangEngineFacade {
    conversation_repo: Box<dyn ConversationRepositoryContract>,
    capability_registry: CapabilityRegistry,
}

impl DiLangEngineFacade {
    pub fn new() -> Self {
        Self {
            conversation_repo: Box::new(ConversationRepositoryImpl::new()),
            capability_registry: CapabilityRegistry::new(),
        }
    }

    /// Global engine cold start initialization
    pub fn initialize(&self) -> Result<()> {
        AppLifecycleManager::cold_start()
    }

    /// Graceful engine shutdown
    pub fn shutdown(&self) -> Result<()> {
        AppLifecycleManager::shutdown()
    }

    /// Start a new dialogue roleplay conversation
    pub fn conversation_start(&self, scenario_id: &str) -> Result<Conversation> {
        self.conversation_repo.start(scenario_id)
    }

    /// Reply to an ongoing conversation
    pub fn conversation_reply(&self, conversation_id: &str, user_text: &str) -> Result<String> {
        self.conversation_repo.reply(conversation_id, user_text)
    }

    /// Lookup vocabulary term
    pub fn vocabulary_lookup(&self, term: &str, target_lang: &str) -> Result<Option<Vocabulary>> {
        Ok(Some(Vocabulary {
            id: "v-001".to_string(),
            term: term.to_string(),
            lemma: term.to_string(),
            pos: "noun".to_string(),
            cefr_level: "A1".to_string(),
            definition: format!("Definition for {} ({})", term, target_lang),
            example_sentence: format!("Example sentence containing {}", term),
        }))
    }

    /// Fetch next due review card
    pub fn review_next(&self) -> Result<Option<ReviewCard>> {
        Ok(None)
    }

    /// Compute analytics progress snapshot
    pub fn analytics_snapshot(&self) -> Result<ProgressSnapshot> {
        Ok(ProgressSnapshot {
            total_known_words: 150,
            total_mastered_grammar: 12,
            total_practice_hours: 4.5,
            average_retention_rate: 0.92,
        })
    }

    /// Query registered subsystem provider capability
    pub fn query_capability(&self, cap_name: &str) -> Option<String> {
        let cap = match cap_name {
            "conversation" => Capability::Conversation,
            "stt" => Capability::SpeechToText,
            "tts" => Capability::TextToSpeech,
            _ => return None,
        };
        self.capability_registry.get_provider(cap).map(|p| p.name)
    }

    /// Collect internal health metrics
    pub fn get_internal_metrics(&self) -> InternalMetrics {
        MetricsCollector::collect()
    }

    /// Start P2P CRDT sync
    pub fn sync_start(&self) -> Result<String> {
        Ok("Sync Engine Initialized".to_string())
    }
}
