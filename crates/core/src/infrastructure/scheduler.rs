//! Task Scheduler & Execution Queue System

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub enum TaskPriority {
    Low,
    Normal,
    High,
    Critical,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TaskJob {
    pub id: String,
    pub name: String,
    pub priority: TaskPriority,
    pub retries_left: u32,
}

pub struct Scheduler;

impl Scheduler {
    pub fn new() -> Self {
        Self
    }

    pub fn schedule_task(&self, job: TaskJob) -> anyhow::Result<()> {
        tracing::info!("Scheduled Task: {} [Priority: {:?}]", job.name, job.priority);
        Ok(())
    }
}
