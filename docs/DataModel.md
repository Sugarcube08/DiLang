# DiLang — Domain Data Model Specification

**Version**: 2.0-RESET  
**Status**: Authoritative  

---

## 1. Primary Domain Entities

### `DiLangUser`
- `UserId id`: Unique user identifier.
- `String username`: System handle.
- `String email`: Contact identifier.
- `Profile profile`: Display name, native language, timezone.
- `List<LanguageProfile> languageProfiles`: Target languages, CEFR level, daily goal, brain model, AI coach persona.

### `UniversalKnowledgeGraph`
- `List<KnowledgeNode> allNodes`: Graph nodes representing lemmas, grammar rules, and phrases.
- `List<KnowledgeEdge> allEdges`: Prerequisites and contextual relationships.

### `FsrsItemState`
- `double stability`: Item stability $S$ in days.
- `double difficulty`: Item difficulty $D$ ($1.0 - 10.0$).
- `int reps`: Total review count.
- `int lapses`: Incorrect recall count.
- `DateTime lastReviewed`: Timestamp of last review.
- `DateTime due`: Next scheduled review timestamp.

### `LearningReplayTranscript`
- `String transcriptId`: Unique replay ID.
- `String sessionId`: Active session ID.
- `String scenarioId`: Executed scenario ID.
- `List<LearningReplayTurn> turns`: Turn-by-turn dialogue, learner responses, corrections, and phonetic scores.
- `int speakingConfidenceBefore`: Initial confidence score.
- `int speakingConfidenceAfter`: Updated confidence score.
- `String evidenceSummary`: Quantitative evidence summary.
