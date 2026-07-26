use core;
use core::api::DiLangEngineFacade;

pub fn ping() -> String {
    core::ping_core()
}

pub fn check_db_health() -> String {
    match core::check_db_health() {
        Ok(msg) => msg,
        Err(err) => format!("Database Error: {}", err),
    }
}

pub fn get_startup_state() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.get_startup_state() {
        core::api::StartupState::NeedsProfile => "NeedsProfile".to_string(),
        core::api::StartupState::NeedsLanguages => "NeedsLanguages".to_string(),
        core::api::StartupState::NeedsPermissions => "NeedsPermissions".to_string(),
        core::api::StartupState::NeedsModels => "NeedsModels".to_string(),
        core::api::StartupState::Ready => "Ready".to_string(),
    }
}

#[allow(clippy::too_many_arguments)]
pub fn create_user_profile(
    username: String,
    native_lang: String,
    target_lang: String,
    avatar: String,
    age: u32,
    country: String,
    timezone: String,
    daily_minutes: u32,
) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.create_user_profile(
        &username,
        &native_lang,
        &target_lang,
        &avatar,
        if age > 0 { Some(age) } else { None },
        &country,
        &timezone,
        daily_minutes,
    ) {
        Ok(user) => serde_json::to_string(&user).unwrap_or_default(),
        Err(err) => format!("Error: {}", err),
    }
}

pub fn get_active_user() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.get_active_user() {
        Ok(Some(user)) => serde_json::to_string(&user).unwrap_or_default(),
        Ok(None) => "".to_string(),
        Err(err) => format!("Error: {}", err),
    }
}

pub fn get_available_scenarios() -> String {
    let engine = DiLangEngineFacade::new();
    let scenarios = engine.get_available_scenarios();
    serde_json::to_string(&scenarios).unwrap_or_default()
}

pub fn start_conversation(scenario_id: String) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.conversation_start(&scenario_id) {
        Ok(conv) => conv.id,
        Err(err) => format!("Error: {}", err),
    }
}

pub fn send_dialogue_turn(conversation_id: String, text: String) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.conversation_reply(&conversation_id, &text) {
        Ok(reply) => reply,
        Err(err) => format!("Error: {}", err),
    }
}

pub fn get_conversation_history(conversation_id: String) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.get_conversation_history(&conversation_id) {
        Ok(msgs) => serde_json::to_string(&msgs).unwrap_or_default(),
        Err(err) => format!("Error: {}", err),
    }
}

pub fn install_model(name: String, version: String, content: Vec<u8>) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.install_model(&name, &version, &content) {
        Ok(rec) => serde_json::to_string(&rec).unwrap_or_default(),
        Err(err) => format!("Error: {}", err),
    }
}

pub fn list_installed_models() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.list_installed_models() {
        Ok(models) => serde_json::to_string(&models).unwrap_or_default(),
        Err(err) => format!("Error: {}", err),
    }
}

pub fn get_system_resource_budget() -> String {
    let engine = DiLangEngineFacade::new();
    let budget = engine.get_system_resource_budget();
    serde_json::to_string(&budget).unwrap_or_default()
}

pub fn get_analytics_snapshot() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.analytics_snapshot() {
        Ok(snap) => format!(
            "Known Words: {}, Mastered Grammar: {}, Practice Hours: {:.1}h",
            snap.total_known_words, snap.total_mastered_grammar, snap.total_practice_hours
        ),
        Err(err) => format!("Error: {}", err),
    }
}

pub fn query_capability(cap_name: String) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.query_capability(&cap_name) {
        Some(provider) => provider,
        None => "Capability Not Registered".to_string(),
    }
}

pub fn shutdown_engine() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.shutdown() {
        Ok(_) => "Engine Shutdown OK".to_string(),
        Err(err) => format!("Error: {}", err),
    }
}
