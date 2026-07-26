//! CRDT & E2EE Peer-to-Peer Synchronization Interface

use anyhow::Result;

pub trait SyncEngine: Send + Sync {
    fn start_p2p_discovery(&self) -> Result<()>;
    fn export_encrypted_bundle(&self) -> Result<Vec<u8>>;
}
