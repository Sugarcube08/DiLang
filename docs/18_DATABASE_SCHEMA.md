# 18. Database Schema & Event Projection Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Relational Projection Schema

---

## 1. Append-Only Event Store Table (`domain_event_store`)

The `domain_event_store` table is the immutable event journal. Zero `UPDATE` or `DELETE` statements are permitted.

```sql
CREATE TABLE domain_event_store (
    sequence_number INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id TEXT NOT NULL UNIQUE,
    aggregate_id TEXT NOT NULL,
    event_type TEXT NOT NULL,
    producer_module TEXT NOT NULL,
    schema_version INTEGER NOT NULL DEFAULT 1,
    payload_protobuf BLOB NOT NULL,
    timestamp_epoch_ms INTEGER NOT NULL
);

CREATE INDEX idx_event_aggregate ON domain_event_store (aggregate_id);
CREATE INDEX idx_event_type ON domain_event_store (event_type);
CREATE INDEX idx_event_timestamp ON domain_event_store (timestamp_epoch_ms);
```

---

## 2. Relational Read Projections

Read tables serve as fast, indexed query projections updated deterministically by event handlers.

### 2.1 Learners Projection (`learners`)
```sql
CREATE TABLE learners (
    learner_id TEXT PRIMARY KEY,
    native_language TEXT NOT NULL,
    target_language TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
);
```

### 2.2 Vocabulary Entries Projection (`vocabulary_entries`)
```sql
CREATE TABLE vocabulary_entries (
    id TEXT PRIMARY KEY,
    lemma TEXT NOT NULL,
    part_of_speech TEXT NOT NULL,
    cefr_level TEXT NOT NULL,
    frequency_rank INTEGER NOT NULL,
    json_data TEXT NOT NULL
);

CREATE INDEX idx_vocab_lemma ON vocabulary_entries (lemma);
CREATE INDEX idx_vocab_cefr ON vocabulary_entries (cefr_level);
```

### 2.3 Learner Progress & Review Queue (`learner_progress`)
```sql
CREATE TABLE learner_progress (
    item_key TEXT PRIMARY KEY,
    stability REAL NOT NULL,
    difficulty REAL NOT NULL,
    reps INTEGER NOT NULL,
    lapses INTEGER NOT NULL,
    mastery_level TEXT NOT NULL,
    last_reviewed_at INTEGER NOT NULL,
    due_at INTEGER NOT NULL
);

CREATE INDEX idx_progress_due ON learner_progress (due_at);
```
