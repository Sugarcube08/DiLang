//! Plugin System Trait Interface for Language Packs & Scenario Bundles

use anyhow::Result;

pub trait PluginHost: Send + Sync {
    fn load_plugin_bundle(&self, bundle_path: &str) -> Result<String>;
}
