# ADR-0009: Offline-First Data Model & Peer-to-Peer Sync Architecture

## Status
🟢 **ACCEPTED** (2026-07-26)

---

## Context & Problem Statement
Users practice across multiple personal devices (e.g. desktop at home, mobile on the go). Progress, FSRS card logs, and custom vocabulary must sync seamlessly between devices without requiring a centralized cloud server.

---

## Decision Drivers
- Data privacy and zero reliance on central databases.
- Automatic conflict resolution across offline review sessions.
- End-to-end local network discovery (mDNS / Local P2P).

---

## Decision
Adopt a **Conflict-Free Replicated Data Type (CRDT)** architecture backed by local SQLite storage. Device synchronization operates peer-to-peer over local Wi-Fi or encrypted export bundles using state-based CRDT delta merging.

---

## Consequences
### Positive:
- True data sovereignty: zero central server dependency or cloud subscription.
- Seamless offline reviews on mobile merge deterministically into desktop graphs.

### Negative:
- Initial implementation complexity of CRDT vector clock merge logic in Rust.
