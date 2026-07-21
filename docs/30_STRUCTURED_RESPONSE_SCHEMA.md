# 30. Structured Response & Event Schema Specification — DiLang

**Document Version:** 2.0.0  
**Status:** Approved / Source of Truth

---

## 1. Response Format Contract

Every LLM completion must conform to the JSON schema:

```json
{
  "response": "Ich trinke gerne Tee.",
  "extractedVocabulary": ["trinken", "Tee"],
  "grammarErrors": [],
  "conversationStatus": "IN_PROGRESS"
}
```
