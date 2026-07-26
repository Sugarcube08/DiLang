//! Phase 5 Shared Infrastructure Subsystem Baseline

pub mod capability_registry;
pub mod config;
pub mod downloader;
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
pub use downloader::{FileVerifier, ModelDownloader};
pub use errors::{AppError, ErrorSeverity};
pub use feature_flags::FeatureFlags;
pub use logging::{emit_structured_log, StructuredLogEntry};
pub use metrics::{InternalMetrics, MetricsCollector};
pub use model_manager::{InstalledModelRecord, ModelManager};
pub use resource_manager::{ResourceManager, SystemBudget};
pub use result::CoreResult;
pub use scheduler::{Scheduler, TaskJob, TaskPriority};
