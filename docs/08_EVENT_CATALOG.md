# 08. Domain Event Catalog & Protobuf Schemas — DiLang

**Document Version:** 1.0.0  
**Status:** Source of Truth — Event Contracts

---

## 1. Event Structure & Immutability Rules

All events in DiLang are immutable structs serialized using **Protocol Buffers v3**. Every event record is persisted to `domain_event_store` with standard header metadata:

```protobuf
syntax = "proto3";

package dilang.events;

import "google/protobuf/timestamp.proto";

message EventHeader {
  string event_id = 1;
  string aggregate_id = 2;
  int64 sequence_number = 3;
  google.protobuf.Timestamp timestamp = 4;
  string producer_module = 5;
  int32 schema_version = 6;
}
```

---

## 2. Event Catalog by Bounded Context

### 2.1 Vocabulary Events

#### `LexicalUnitReviewed`
Emitted when a user attempts a vocabulary recall item.

```protobuf
message LexicalUnitReviewedEvent {
  EventHeader header = 1;
  string lexical_unit_id = 2;
  int32 user_rating = 3; // 1=Again, 2=Hard, 3=Good, 4=Easy
  double response_time_ms = 4;
  double new_stability = 5;
  double new_difficulty = 6;
  google.protobuf.Timestamp next_due_date = 7;
}
```

#### `VocabularyExtractedFromContext`
Emitted by Conversation / Reading context when new unknown terms are encountered during dialogues.

```protobuf
message VocabularyExtractedEvent {
  EventHeader header = 1;
  string lexical_unit_text = 2;
  string context_sentence = 3;
  string source_module = 4;
}
```

---

### 2.2 Conversation Events

#### `ConversationTurnCompleted`
Emitted whenever a dialogue turn is executed between user and local LLM agent.

```protobuf
message ConversationTurnCompletedEvent {
  EventHeader header = 1;
  string session_id = 2;
  string user_audio_path = 3;
  string user_transcription = 4;
  string agent_response_text = 5;
  string agent_audio_path = 6;
  int64 user_speech_duration_ms = 7;
}
```

---

### 2.3 Pronunciation Events

#### `PhonemeEvaluated`
Emitted after `whisper.cpp` acoustic evaluation parses phoneme timing and accuracy.

```protobuf
message PhonemeEvaluatedEvent {
  EventHeader header = 1;
  string phoneme_symbol = 2;
  double target_duration_ms = 3;
  double actual_duration_ms = 4;
  double acoustic_confidence_score = 5; // 0.0 to 1.0
  bool is_accurate = 6;
}
```

---

### 2.4 Sync & Engine Events

#### `SyncBlockExported`
Emitted when a node bundles local events for local-first peer sync.

```protobuf
message SyncBlockExportedEvent {
  EventHeader header = 1;
  string device_id = 2;
  int64 start_sequence = 3;
  int64 end_sequence = 4;
  bytes lz4_payload = 5;
}
```
