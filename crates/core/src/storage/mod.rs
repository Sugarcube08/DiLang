//! Storage Subsystem Trait Interface & SQLite Infrastructure

pub mod schema;

use anyhow::Result;

pub trait StorageEngine: Send + Sync {
    fn initialize(&self) -> Result<()>;
    fn check_health(&self) -> Result<String>;
}

pub struct SqliteStorageEngine;

impl SqliteStorageEngine {
    pub fn new() -> Self {
        Self
    }
}

impl StorageEngine for SqliteStorageEngine {
    fn initialize(&self) -> Result<()> {
        schema::initialize_schema()?;
        Ok(())
    }

    fn check_health(&self) -> Result<String> {
        crate::check_db_health().map_err(|e| anyhow::anyhow!(e))
    }
}
