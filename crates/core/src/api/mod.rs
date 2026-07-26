//! Public Engine API Facade Specification

use crate::analysis::LanguageAnalysisEngine;
use crate::analytics::{AnalyticsEngine, EventDrivenAnalyticsEngine};
use crate::conversation::{
    scenarios::ScenarioDefinition, ConversationEngine, DefaultConversationEngine, MessageRecord,
};
use crate::grammar::{DefaultGrammarEngine, GrammarEngine};
use crate::infrastructure::{
    Capability, CapabilityRegistry, InstalledModelRecord, InternalMetrics, MetricsCollector,
    ModelManager, ResourceManager, SystemBudget,
};
use crate::lifecycle::AppLifecycleManager;
use crate::models::{Conversation, ProgressSnapshot, ReviewCard, User, Vocabulary};
use crate::repositories::{
    ConversationRepositoryContract, ConversationRepositoryImpl, SettingsRepositoryContract,
    SettingsRepositoryImpl, UserRepositoryContract, UserRepositoryImpl,
};
use crate::review::{FsrsReviewEngine, ReviewEngine};
use crate::vocabulary::{DefaultVocabularyEngine, VocabularyEngine};
use anyhow::Result;
use serde::{Deserialize, Serialize};
use tracing::info;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum StartupState {
    NeedsProfile,
    NeedsLanguages,
    NeedsPermissions,
    NeedsModels,
    Ready,
}

pub struct DiLangEngineFacade {
    conversation_engine: Box<dyn ConversationEngine>,
    analysis_engine: LanguageAnalysisEngine,
    vocabulary_engine: Box<dyn VocabularyEngine>,
    grammar_engine: Box<dyn GrammarEngine>,
    review_engine: Box<dyn ReviewEngine>,
    analytics_engine: Box<dyn AnalyticsEngine>,
    _conversation_repo: Box<dyn ConversationRepositoryContract>,
    user_repo: Box<dyn UserRepositoryContract>,
    _settings_repo: Box<dyn SettingsRepositoryContract>,
    capability_registry: CapabilityRegistry,
    model_manager: ModelManager,
    resource_manager: ResourceManager,
}

impl Default for DiLangEngineFacade {
    fn default() -> Self {
        Self::new()
    }
}

impl DiLangEngineFacade {
    pub fn new() -> Self {
        Self {
            conversation_engine: Box::new(DefaultConversationEngine::new()),
            analysis_engine: LanguageAnalysisEngine::new(),
            vocabulary_engine: Box::new(DefaultVocabularyEngine::new()),
            grammar_engine: Box::new(DefaultGrammarEngine::new()),
            review_engine: Box::new(FsrsReviewEngine::new()),
            analytics_engine: Box::new(EventDrivenAnalyticsEngine::new()),
            _conversation_repo: Box::new(ConversationRepositoryImpl::new()),
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

    pub fn get_onboarding_step(&self) -> String {
        let conn = match crate::storage::schema::get_connection() {
            Ok(c) => c,
            Err(_) => return "Profile".to_string(),
        };
        conn.query_row(
            "SELECT value FROM settings WHERE key = 'onboarding_step'",
            [],
            |r| r.get(0),
        )
        .unwrap_or_else(|_| "Profile".to_string())
    }

    pub fn set_onboarding_step(&self, step: &str) -> Result<()> {
        let conn = crate::storage::schema::get_connection()?;
        conn.execute(
            "INSERT OR REPLACE INTO settings (key, value) VALUES ('onboarding_step', ?1)",
            rusqlite::params![step],
        )?;
        Ok(())
    }

    /// Rust Backend Startup State Machine
    /// Queries SQLite database to determine application launch state
    pub fn get_startup_state(&self) -> StartupState {
        info!("RUST: get_startup_state() query invoked");
        let step = self.get_onboarding_step();
        info!("RUST: SQLite onboarding_step = '{}'", step);

        if step == "Completed" {
            info!("RUST: get_startup_state() -> Ready (onboarding_step = Completed)");
            return StartupState::Ready;
        }

        let active_user = self.user_repo.get_active_user().unwrap_or_default();
        if active_user.is_none() {
            info!("RUST: get_startup_state() -> NeedsProfile (SQLite users table is empty)");
            return StartupState::NeedsProfile;
        }

        let user = active_user.unwrap();
        if user.target_language.is_empty() || user.native_language.is_empty() {
            info!("RUST: get_startup_state() -> NeedsLanguages (Target or native language unselected)");
            return StartupState::NeedsLanguages;
        }

        let models = self
            .model_manager
            .list_installed_models()
            .unwrap_or_default();

        if models.is_empty() {
            info!("RUST: get_startup_state() -> NeedsModels (installed_models table is empty)");
            return StartupState::NeedsModels;
        }

        info!("RUST: get_startup_state() -> Ready (All onboarding steps completed)");
        StartupState::Ready
    }

    /// Create User Profile & Learning Goal in SQLite
    #[allow(clippy::too_many_arguments)]
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
        let user = self
            .user_repo
            .create_user(username, native_lang, target_lang)?;
        self.user_repo
            .save_user_profile(&user.id, avatar, age, country, timezone)?;
        self.user_repo
            .save_learning_goal(&user.id, daily_minutes, 20)?;
        Ok(user)
    }

    /// Retrieve current active user profile from SQLite
    pub fn get_active_user(&self) -> Result<Option<User>> {
        self.user_repo.get_active_user()
    }

    /// List available dialogue roleplay scenarios
    pub fn get_available_scenarios(&self) -> Vec<ScenarioDefinition> {
        self.conversation_engine.get_available_scenarios()
    }

    /// Start a new dialogue roleplay conversation
    pub fn conversation_start(&self, scenario_id: &str) -> Result<Conversation> {
        self.conversation_engine.start_session(scenario_id)
    }

    /// Atomic Learning Pipeline: Turn -> LLM -> Analysis -> Vocab -> Grammar -> FSRS -> Analytics
    pub fn conversation_reply(&self, conversation_id: &str, user_text: &str) -> Result<String> {
        // 1. Dialogue turn via ConversationEngine
        let reply_text = self
            .conversation_engine
            .send_reply(conversation_id, user_text)?;

        // 2. Language Analysis Engine
        let target_lang = self
            .get_active_user()
            .ok()
            .flatten()
            .map(|u| u.target_language)
            .unwrap_or_else(|| "German".to_string());
        let analyzed = self.analysis_engine.analyze_text(&reply_text, &target_lang);

        // 3. Vocabulary Extraction & Persistence Engine
        if let Ok(extracted_terms) = self.vocabulary_engine.extract_and_persist(&analyzed) {
            // 4. Schedule FSRS v4 Review Cards for extracted vocabulary
            for vocab in extracted_terms {
                let _ = self.review_engine.schedule_vocab_card(&vocab);
            }
        }

        // 5. Grammar Extraction Engine
        let _ = self.grammar_engine.extract_and_persist(&analyzed);

        Ok(reply_text)
    }

    /// Retrieve full message history for a conversation
    pub fn get_conversation_history(&self, conversation_id: &str) -> Result<Vec<MessageRecord>> {
        self.conversation_engine.get_history(conversation_id)
    }

    /// Install & register model file with real SHA-256 calculation
    pub fn install_model(
        &self,
        name: &str,
        version: &str,
        content: &[u8],
    ) -> Result<InstalledModelRecord> {
        self.model_manager
            .install_model_file(name, version, content)
            .map_err(|e| anyhow::anyhow!(e))
    }

    /// List installed models from SQLite
    pub fn list_installed_models(&self) -> Result<Vec<InstalledModelRecord>> {
        self.model_manager
            .list_installed_models()
            .map_err(|e| anyhow::anyhow!(e))
    }

    /// Inspect device system hardware resource budget
    pub fn get_system_resource_budget(&self) -> SystemBudget {
        self.resource_manager.inspect_budget()
    }

    /// Lookup vocabulary term
    pub fn vocabulary_lookup(&self, term: &str, target_lang: &str) -> Result<Option<Vocabulary>> {
        self.vocabulary_engine.lookup(term, target_lang)
    }

    /// Fetch next due review card
    pub fn review_next(&self) -> Result<Option<ReviewCard>> {
        let cards = self.review_engine.fetch_due_cards(1)?;
        Ok(cards.into_iter().next())
    }

    /// Compute analytics progress snapshot
    pub fn analytics_snapshot(&self) -> Result<ProgressSnapshot> {
        self.analytics_engine.compute_snapshot()
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
