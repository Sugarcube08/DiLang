//! Native Core Composition Root & Dependency Container

use crate::events::EventBus;
use crate::workers::WorkerManager;
use std::sync::Arc;

pub struct CoreContainer {
    pub event_bus: Arc<EventBus>,
    pub worker_manager: Arc<WorkerManager>,
}

impl Default for CoreContainer {
    fn default() -> Self {
        Self::new()
    }
}

impl CoreContainer {
    pub fn new() -> Self {
        Self {
            event_bus: crate::events::global_event_bus(),
            worker_manager: Arc::new(WorkerManager::new()),
        }
    }
}
