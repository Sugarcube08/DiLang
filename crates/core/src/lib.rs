use std::path::PathBuf;
use rusqlite::Connection;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;
use once_cell::sync::Lazy;
use std::sync::Mutex;

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

    // Determine local data directory or in-memory fallback
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
        .query_row("SELECT 'SQLite 3 is Healthy' AS status;", [], |row| row.get(0))
        .map_err(|e| format!("Database health check query failed: {}", e))?;

    info!("Database Health Check Result: {}", result);
    Ok(result)
}

fn get_db_path() -> Option<PathBuf> {
    dirs::data_dir().map(|mut p| {
        p.push("DiLang");
        p.push("database.db");
        p
    })
}

#[cfg(test)]
mod tests {
    use super::*;

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
}
