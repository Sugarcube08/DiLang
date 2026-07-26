use core;

/// Heartbeat ping function exposed via FFI to Flutter
pub fn ping() -> String {
    core::ping_core()
}

/// SQLite database health check exposed via FFI to Flutter
pub fn check_db_health() -> String {
    match core::check_db_health() {
        Ok(msg) => msg,
        Err(err) => format!("Database Error: {}", err),
    }
}
