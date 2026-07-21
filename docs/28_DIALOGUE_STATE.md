# 28. Multi-Turn Dialogue State Specification — DiLang

**Document Version:** 2.0.0  
**Status:** Approved / Source of Truth

---

## 1. Dialogue State Machine

Dialogue state tracks conversation turns, active communicative intents, and context sliding windows.

```
 [IDLE] ──(startSession)──> [ACTIVE_TURN] ──(userSpeech)──> [PROCESSING_STT_LLM]
                                 ▲                                 │
                                 │                                 v
                                 └─────────(agentResponse)─────────┘
```
