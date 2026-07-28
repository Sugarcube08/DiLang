use core;
use core::api::DiLangEngineFacade;
use std::path::PathBuf;

pub fn ping() -> String {
    core::ping_core()
}

pub fn init_app_paths(base_path: String) -> String {
    let path = PathBuf::from(&base_path);
    core::infrastructure::ModelManager::set_custom_base_path(path.clone());
    let _ = std::fs::create_dir_all(&path);
    format!("Initialized storage path: {}", path.display())
}

pub fn check_db_health() -> String {
    match core::check_db_health() {
        Ok(msg) => msg,
        Err(err) => format!("Database Error: {}", err),
    }
}

pub fn get_onboarding_step() -> String {
    let engine = DiLangEngineFacade::new();
    engine.get_onboarding_step()
}

pub fn set_onboarding_step(step: String) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.set_onboarding_step(&step) {
        Ok(_) => "OK".to_string(),
        Err(e) => format!("Error: {}", e),
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
        Ok(snap) => serde_json::to_string(&snap).unwrap_or_default(),
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

use crate::frb_generated::StreamSink;

pub fn get_model_registry() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.get_model_registry() {
        Ok(registry) => serde_json::to_string(&registry).unwrap_or_default(),
        Err(err) => format!("Error: {}", err),
    }
}

pub fn get_supported_languages() -> String {
    let engine = DiLangEngineFacade::new();
    let langs = engine.get_supported_languages();
    serde_json::to_string(&langs).unwrap_or_default()
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct FfiDownloadProgress {
    pub model_id: String,
    pub bytes_downloaded: u64,
    pub total_bytes: u64,
    pub bytes_per_sec: u64,
    pub eta_seconds: u64,
    pub status: String,
}

pub fn download_model_stream(model_id: String, sink: StreamSink<FfiDownloadProgress>) -> String {
    core::infrastructure::log_info(&format!("[FFI THREAD] Spawning model download worker thread for '{}'", model_id));
    let model_id_clone = model_id.clone();
    std::thread::spawn(move || {
        core::infrastructure::log_info(&format!("[FFI WORKER] Worker thread running for '{}'", model_id_clone));
        let engine = DiLangEngineFacade::new();
        match engine.download_registry_model(&model_id_clone, |prog| {
            let _ = sink.add(FfiDownloadProgress {
                model_id: prog.model_id,
                bytes_downloaded: prog.bytes_downloaded,
                total_bytes: prog.total_bytes,
                bytes_per_sec: prog.bytes_per_sec,
                eta_seconds: prog.eta_seconds,
                status: prog.status,
            });
        }) {
            Ok(rec) => {
                core::infrastructure::log_info(&format!("[FFI WORKER SUCCESS] Model '{}' downloaded and registered cleanly: {:?}", rec.name, rec.path));
                let _ = sink.add(FfiDownloadProgress {
                    model_id: model_id_clone.clone(),
                    bytes_downloaded: rec.size_bytes,
                    total_bytes: rec.size_bytes,
                    bytes_per_sec: 0,
                    eta_seconds: 0,
                    status: "Installed".to_string(),
                });
            }
            Err(err) => {
                core::infrastructure::log_info(&format!("[FFI WORKER ERROR] Model download failed for '{}': {}", model_id_clone, err));
                let _ = sink.add(FfiDownloadProgress {
                    model_id: model_id_clone.clone(),
                    bytes_downloaded: 0,
                    total_bytes: 0,
                    bytes_per_sec: 0,
                    eta_seconds: 0,
                    status: format!("Failed: {}", err),
                });
            }
        }
    });
    "Started".to_string()
}

pub fn transcribe_audio(audio_bytes: Vec<u8>) -> String {
    let engine = DiLangEngineFacade::new();
    match engine.transcribe_audio(&audio_bytes) {
        Ok(text) => text,
        Err(err) => format!("Error: {}", err),
    }
}

pub fn synthesize_speech(text: String) -> Vec<u8> {
    let engine = DiLangEngineFacade::new();
    engine.synthesize_speech(&text).unwrap_or_default()
}

pub fn get_runtime_diagnostics() -> String {
    let engine = DiLangEngineFacade::new();
    let installed_models = engine.list_installed_models().unwrap_or_default();
    let budget = engine.get_system_resource_budget();
    let db_path = core::get_db_path()
        .map(|p| p.to_string_lossy().to_string())
        .unwrap_or_default();

    let diag = serde_json::json!({
        "runtime_version": "0.1.0",
        "sqlite_database_path": db_path,
        "sqlite_status": "Healthy",
        "installed_models_count": installed_models.len(),
        "installed_models": installed_models,
        "max_cpu_threads": budget.max_cpu_threads,
        "max_ram_mb": budget.max_ram_mb,
        "gpu_available": budget.gpu_available,
        "qwen_loader": "llama.cpp GGUF",
        "whisper_loader": "whisper.cpp GGML",
        "piper_loader": "Piper ONNX",
    });

    serde_json::to_string_pretty(&diag).unwrap_or_default()
}

pub fn shutdown_engine() -> String {
    let engine = DiLangEngineFacade::new();
    match engine.shutdown() {
        Ok(_) => "Engine Shutdown OK".to_string(),
        Err(err) => format!("Error: {}", err),
    }
}
