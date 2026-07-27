use once_cell::sync::Lazy;
use rusqlite::Connection;
use std::path::PathBuf;
use std::sync::Mutex;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;

pub mod analysis;
pub mod analytics;
pub mod api;
pub mod app_runtime;
pub mod conversation;
pub mod di;
pub mod events;
pub mod grammar;
pub mod infrastructure;
pub mod lifecycle;
pub mod models;
pub mod plugin_api;
pub mod providers;
pub mod repositories;
pub mod review;
pub mod storage;
pub mod sync;
pub mod vocabulary;
pub mod workers;

static LOG_INITIALIZED: Lazy<Mutex<bool>> = Lazy::new(|| Mutex::new(false));

/// Initialize logging system using tracing and tracing-subscriber
pub fn init_logging() {
    let mut guard = LOG_INITIALIZED.lock().unwrap();
    if !*guard {
        let subscriber = FmtSubscriber::builder()
            .with_max_level(Level::INFO)
            .with_target(false)
            .finish();
        let _ = tracing::subscriber::set_global_default(subscriber);
        *guard = true;
        info!("DiLang Core Tracing Logger Initialized");
    }
}

/// Core heartbeat test function
pub fn ping_core() -> String {
    init_logging();
    info!("ping_core called successfully");
    "Rust is alive".to_string()
}

/// SQLite Database initialization & health check
pub fn check_db_health() -> Result<String, String> {
    init_logging();
    info!("Performing SQLite health check...");

    let db_path = get_db_path();

    let conn = if let Some(path) = &db_path {
        info!("Connecting to SQLite database at: {:?}", path);
        if let Some(parent) = path.parent() {
            std::fs::create_dir_all(parent).map_err(|e| e.to_string())?;
        }
        Connection::open(path).map_err(|e| format!("Failed to open SQLite DB: {}", e))?
    } else {
        info!("Connecting to in-memory SQLite database");
        Connection::open_in_memory().map_err(|e| format!("Failed to open in-memory DB: {}", e))?
    };

    let result: String = conn
        .query_row("SELECT 'SQLite 3 is Healthy' AS status;", [], |row| {
            row.get(0)
        })
        .map_err(|e| format!("Database health check query failed: {}", e))?;

    info!("Database Health Check Result: {}", result);
    Ok(result)
}

/// Explicit Environment-Based Path Resolver (DILANG_ENV=production|development|test)
pub fn get_db_path() -> Option<PathBuf> {
    let env_mode = std::env::var("DILANG_ENV").unwrap_or_else(|_| {
        if cfg!(test) {
            "test".to_string()
        } else {
            "production".to_string()
        }
    });

    match env_mode.as_str() {
        "test" => {
            let mut p = std::env::temp_dir();
            p.push("dilang-test");
            p.push("database.db");
            Some(p)
        }
        "development" => dirs::data_dir().map(|mut p| {
            p.push("DiLang-dev");
            p.push("database.db");
            p
        }),
        _ => dirs::data_dir().map(|mut p| {
            p.push("DiLang");
            p.push("database.db");
            p
        }),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use api::{DiLangEngineFacade, StartupState};
    use events::{global_event_bus, ConversationEventPayload};
    use infrastructure::{ConfigManager, FeatureFlags, ModelManager};

    #[test]
    fn test_ping_core() {
        assert_eq!(ping_core(), "Rust is alive");
    }

    #[test]
    fn test_check_db_health() {
        let status = check_db_health();
        assert!(status.is_ok());
        assert_eq!(status.unwrap(), "SQLite 3 is Healthy");
    }

    #[test]
    fn test_first_launch_onboarding_state_machine_flow() {
        let engine = DiLangEngineFacade::new();
        assert!(engine.initialize().is_ok());

        // 1. Check startup state
        let initial_state = engine.get_startup_state();
        assert!(
            initial_state == StartupState::NeedsProfile
                || initial_state == StartupState::NeedsModels
                || initial_state == StartupState::Ready
        );

        // 2. Create Profile
        let user = engine.create_user_profile(
            "TestLearner",
            "English",
            "German",
            "avatar.png",
            Some(25),
            "US",
            "UTC",
            15,
        );
        assert!(user.is_ok());

        // 3. Install All Required Models
        assert!(engine
            .install_model("qwen3-0.6b-instruct-q4_k_m", "v1.0", b"test_bytes")
            .is_ok());
        assert!(engine
            .install_model("whisper-base", "v1.0", b"test_bytes")
            .is_ok());
        assert!(engine
            .install_model("piper-en_US-lessac-medium", "v1.0", b"test_bytes")
            .is_ok());
        assert!(engine.set_onboarding_step("Completed").is_ok());

        // 4. Final State after Profile + All Models installation MUST be Ready
        assert_eq!(engine.get_startup_state(), StartupState::Ready);
    }

    #[test]
    fn test_engine_facade() {
        let engine = DiLangEngineFacade::new();
        assert!(engine.initialize().is_ok());

        let user = engine.create_user_profile(
            "Alex",
            "English",
            "German",
            "avatar.png",
            Some(30),
            "US",
            "UTC",
            15,
        );
        assert!(user.is_ok());
        assert_eq!(user.unwrap().username, "Alex");

        let active_user = engine.get_active_user();
        assert!(active_user.is_ok());
        assert!(active_user.unwrap().is_some());

        let model = engine.install_model("qwen3-0.6b-instruct-q4_k_m", "v1.0", b"test_model_bytes");
        assert!(model.is_ok());

        let installed = engine.list_installed_models();
        assert!(installed.is_ok());
        assert!(!installed.unwrap().is_empty());

        assert!(engine.shutdown().is_ok());
    }

    #[test]
    fn test_end_to_end_vertical_slice_learning_pipeline() {
        let engine = DiLangEngineFacade::new();
        assert!(engine.initialize().is_ok());

        // 1. Start dialogue session
        let conv = engine.conversation_start("cafe_order");
        assert!(conv.is_ok());
        let conv_id = conv.unwrap().id;
        let _ = engine.install_model("qwen3-0.6b-instruct-q4_k_m", "v1.0", b"test_model_bytes");

        // 2. Process user reply through vertical learning pipeline
        let reply = engine.conversation_reply(&conv_id, "Ich möchte einen Kaffee trinken bitte.");
        assert!(reply.is_ok());
        assert!(!reply.unwrap().is_empty());

        // 3. Verify SQLite message history
        let history = engine.get_conversation_history(&conv_id);
        assert!(history.is_ok());
        assert!(history.unwrap().len() >= 3);

        // 4. Verify FSRS review card scheduling & analytics snapshot computation
        let snapshot = engine.analytics_snapshot();
        assert!(snapshot.is_ok());
        let snap = snapshot.unwrap();
        assert!(snap.total_known_words > 0);
    }

    #[test]
    fn test_event_bus() {
        let bus = global_event_bus();
        let payload = ConversationEventPayload::ConversationStarted {
            scenario_id: "test".to_string(),
        };
        assert!(bus.publish("conversation", &payload).is_ok());
    }

    #[test]
    fn test_infrastructure() {
        let config = ConfigManager::new();
        assert_eq!(config.get().ai.quantization_profile, "Q4_K_M");
        let flags = FeatureFlags::default();
        assert!(flags.is_enabled("conversation"));
        let model_mgr = ModelManager::new();
        let temp_dir = std::env::temp_dir().join("test_sha256.bin");
        std::fs::write(&temp_dir, b"sha_test_content").unwrap();
        let verified = model_mgr.verify_checksum(
            &temp_dir,
            "b40d6c0733d7eb3d05267b2d5eb6627be95ca8ed7b15a6b0c2cb4172a6b2ed4a",
        );
        assert!(verified.is_ok());
    }
}
