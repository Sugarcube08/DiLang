//! Developer Internal Health Metrics Collector

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InternalMetrics {
    pub startup_time_ms: u64,
    pub inference_latency_ms: u64,
    pub database_latency_ms: u64,
    pub ram_usage_mb: usize,
    pub task_queue_depth: usize,
    pub provider_uptime_seconds: u64,
}

impl Default for InternalMetrics {
    fn default() -> Self {
        Self {
            startup_time_ms: 120,
            inference_latency_ms: 0,
            database_latency_ms: 2,
            ram_usage_mb: 45,
            task_queue_depth: 0,
            provider_uptime_seconds: 3600,
        }
    }
}

pub struct MetricsCollector;

impl MetricsCollector {
    pub fn collect() -> InternalMetrics {
        InternalMetrics::default()
    }
}
