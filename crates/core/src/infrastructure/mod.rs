//! Phase 5 Shared Infrastructure Subsystem Baseline

pub mod capability_registry;
pub mod config;
pub mod errors;
pub mod feature_flags;
pub mod logging;
pub mod metrics;
pub mod model_manager;
pub mod resource_manager;
pub mod result;
pub mod scheduler;

pub use capability_registry::{Capability, CapabilityRegistry, ProviderDescriptor};
pub use config::{AppConfig, ConfigManager};
pub use errors::{AppError, ErrorSeverity};
pub use feature_flags::FeatureFlags;
pub use logging::{StructuredLogEntry, emit_structured_log};
pub use metrics::{InternalMetrics, MetricsCollector};
pub use model_manager::ModelManager;
pub use resource_manager::ResourceManager;
pub use result::CoreResult;
pub use scheduler::{Scheduler, TaskJob, TaskPriority};
