//! Native Core Composition Root & Dependency Container

use std::sync::Arc;
use crate::events::EventBus;
use crate::workers::WorkerManager;

pub struct CoreContainer {
    pub event_bus: Arc<EventBus>,
    pub worker_manager: Arc<WorkerManager>,
}

impl CoreContainer {
    pub fn new() -> Self {
        Self {
            event_bus: crate::events::global_event_bus(),
            worker_manager: Arc::new(WorkerManager::new()),
        }
    }
}
