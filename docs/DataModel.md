# DiLang — Domain Data Model & SQLite Database Schema

**Version**: 2.0-SCHEMA-FROZEN  
**Status**: Frozen & Authoritative Database Architecture  

---

## Module Schema Ownership Matrix

| Module | Table Name | Purpose | Key Indexes |
| :--- | :--- | :--- | :--- |
| **Identity** | `users` | Core user identity record | `PRIMARY KEY (id)` |
| **Identity** | `language_profiles` | Target language goals & AI coach persona | `idx_language_profiles_user` |
| **Learning** | `fsrs_cards` | FSRS-4.5 memory stability & retrievability cards | `idx_fsrs_next_review` |
| **Learning** | `learning_sessions` | Aggregated daily learning sessions | `idx_learning_sessions_user` |
| **Learning** | `learning_reviews` | Individual FSRS card review logs | `idx_reviews_card_id` |
| **Learning** | `missions` | Daily generated learning objectives | `idx_missions_status` |
| **Conversation**| `conversation_sessions` | Dialogue scenario sessions | `idx_conv_sessions_user` |
| **Conversation**| `conversation_turns` | Turn-by-turn dialogue text & phonetics | `idx_conversation_turns_session` |
| **Conversation**| `conversation_replays` | Full replay transcripts & evidence summaries | `idx_replays_session` |
| **Knowledge Graph**| `knowledge_nodes` | Skill DAG concepts & vocabulary lemmas | `idx_knowledge_nodes_word` |
| **Knowledge Graph**| `knowledge_edges` | Prerequisite & semantic links | `idx_knowledge_edges_source` |
| **Knowledge Graph**| `vocabulary` | Target language surface forms & IPA phonetics | `idx_vocabulary_lemma` |
| **Settings** | `settings` | System-wide persistent settings | `PRIMARY KEY (key)` |
| **Settings** | `preferences` | User UI & Audio preferences | `PRIMARY KEY (key)` |
| **Diagnostics**| `runtime_logs` | Structured runtime log entries | `idx_logs_timestamp` |
| **Diagnostics**| `performance_metrics` | Latency & frame rate benchmarks | `idx_metrics_timestamp` |
| **Diagnostics**| `crash_reports` | Exception stack traces & diagnostics | `idx_crashes_timestamp` |

---

## Migration Architecture

All database schema evolutions execute sequentially inside transactions via `SqliteStorageEngine`:

- `0001_initial.sql` — `schema_migrations`, `users`, `language_profiles`
- `0002_learning.sql` — `fsrs_cards`, `learning_sessions`, `learning_reviews`, `missions`
- `0003_conversation.sql` — `conversation_sessions`, `conversation_turns`, `conversation_replays`
- `0004_knowledge_graph.sql` — `knowledge_nodes`, `knowledge_edges`, `vocabulary`
- `0005_settings_and_diagnostics.sql` — `settings`, `preferences`, `runtime_logs`, `performance_metrics`, `crash_reports`
