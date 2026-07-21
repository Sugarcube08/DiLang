# 19. Event Synchronization & Replication Protocol — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Sync Protocol

---

## 1. Local-First Event Replication Pipeline

DiLang synchronization operates at the **event level**, not the database table level. This guarantees deterministic conflict resolution and offline multi-device support.

```
Local Event Log
      │
      ├── 1. Protobuf Wire Serialization
      ├── 2. LZ4 Delta Payload Compression
      ├── 3. AES-GCM Payload Encryption
      ├── 4. Vector Clock & Logical Clock Tagging
      ├── 5. Conflict Resolution Matrix
      ├── 6. Transport Replication (P2P / gRPC)
      └── 7. Target Event Store Append & Projection Replay
```

---

## 2. Vector Clocks & Deterministic Conflict Resolution

Each node maintains a `VectorClock` map `{deviceId: sequenceNumber}`:

1. **Causal Dominance**: If event block $A$ causally dominates event block $B$ ($V_A > V_B$), block $A$ is applied without conflict.
2. **Concurrent Events ($V_A \parallel V_B$)**: Deterministic merge rules resolve concurrent events:
   - For `ReviewCompletedEvent`: The event with the higher `sequence_number` or later cryptographic `timestamp` prevails.
   - For `LearnerNodeState`: FSRS memory state recalculation is replayed chronologically from combined events.
3. **Idempotence**: Every event possesses a globally unique `event_id` (UUIDv4). Re-receiving an existing event is a no-op.
