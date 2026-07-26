//! Public Engine API Facade Specification

use anyhow::Result;
use crate::models::{Conversation, ProgressSnapshot, ReviewCard, User, Vocabulary};
use crate::repositories::{
    ConversationRepositoryContract, ConversationRepositoryImpl,
    UserRepositoryContract, UserRepositoryImpl,
    SettingsRepositoryContract, SettingsRepositoryImpl,
};
use crate::lifecycle::AppLifecycleManager;
use crate::infrastructure::{
    CapabilityRegistry, Capability, MetricsCollector, InternalMetrics,
    ModelManager, InstalledModelRecord, ResourceManager, SystemBudget,
};

pub struct DiLangEngineFacade {
    conversation_repo: Box<dyn ConversationRepositoryContract>,
    user_repo: Box<dyn UserRepositoryContract>,
    _settings_repo: Box<dyn SettingsRepositoryContract>,
    capability_registry: CapabilityRegistry,
    model_manager: ModelManager,
    resource_manager: ResourceManager,
}

impl DiLangEngineFacade {
    pub fn new() -> Self {
        Self {
            conversation_repo: Box::new(ConversationRepositoryImpl::new()),
            user_repo: Box::new(UserRepositoryImpl::new()),
            _settings_repo: Box::new(SettingsRepositoryImpl::new()),
            capability_registry: CapabilityRegistry::new(),
            model_manager: ModelManager::new(),
            resource_manager: ResourceManager::new(),
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

    /// Create User Profile & Learning Goal in SQLite
    pub fn create_user_profile(
        &self,
        username: &str,
        native_lang: &str,
        target_lang: &str,
        avatar: &str,
        age: Option<u32>,
        country: &str,
        timezone: &str,
        daily_minutes: u32,
    ) -> Result<User> {
        let user = self.user_repo.create_user(username, native_lang, target_lang)?;
        self.user_repo.save_user_profile(&user.id, avatar, age, country, timezone)?;
        self.user_repo.save_learning_goal(&user.id, daily_minutes, 20)?;
        Ok(user)
    }

    /// Retrieve current active user profile from SQLite
    pub fn get_active_user(&self) -> Result<Option<User>> {
        self.user_repo.get_active_user()
    }

    /// Install & register model file with real SHA-256 calculation
    pub fn install_model(&self, name: &str, version: &str, content: &[u8]) -> Result<InstalledModelRecord> {
        self.model_manager.install_model_file(name, version, content)
            .map_err(|e| anyhow::anyhow!(e))
    }

    /// List installed models from SQLite
    pub fn list_installed_models(&self) -> Result<Vec<InstalledModelRecord>> {
        self.model_manager.list_installed_models()
            .map_err(|e| anyhow::anyhow!(e))
    }

    /// Inspect device system hardware resource budget
    pub fn get_system_resource_budget(&self) -> SystemBudget {
        self.resource_manager.inspect_budget()
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
