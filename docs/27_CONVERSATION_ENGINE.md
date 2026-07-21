# 27. Conversation Engine Specification — DiLang

**Document Version:** 2.0.0  
**Status:** Approved / Source of Truth — Phase 6

---

## 1. Event-Driven Conversation Philosophy

The **Conversation Engine** acts as a consumer of AI Runtime infrastructure and publishes immutable domain events to the Learning Engine. It never mutates database state or user mastery directly.

```
 User Voice / Text
       │
       v
 Conversation Engine (Session Manager & Dialogue State)
       │
       ├── 1. Query AI Runtime (LlmProvider / SttProvider)
       ├── 2. Validate Structured JSON Response
       └── 3. Publish Domain Events (ConversationTurnCompleted, DialogueErrorDetected)
                               │
                               v
                        Event Bus ──> Learning Engine ──> Storage
```
