//! Centralized Resource & Hardware Manager

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SystemBudget {
    pub max_cpu_threads: usize,
    pub max_ram_mb: usize,
    pub gpu_available: bool,
}

pub struct ResourceManager;

impl ResourceManager {
    pub fn new() -> Self {
        Self
    }

    pub fn inspect_budget(&self) -> SystemBudget {
        SystemBudget {
            max_cpu_threads: num_cpus::get(),
            max_ram_mb: 4096,
            gpu_available: false,
        }
    }
}
