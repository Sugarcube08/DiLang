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

pub fn start_conversation(scenario_id: String) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.conversation_start(&scenario_id) {
        Ok(conv) => conv.id,
        Err(err) => format!("Error: {}", err),
    }
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

pub fn shutdown_engine() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.shutdown() {
        Ok(_) => "Engine Shutdown OK".to_string(),
        Err(err) => format!("Error: {}", err),
    }
}
