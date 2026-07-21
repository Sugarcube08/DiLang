# 20. Repository Contracts Specification — DiLang

**Document Version:** 1.0.0  
**Status:** Approved / Source of Truth — Repository Contracts

---

## 1. Domain Repository Interfaces

Domain code interacts *exclusively* with these abstract interfaces.

```dart
/// Abstract contract for Learner Profile & Knowledge Graph persistence
abstract class LearnerRepositoryContract {
  Future<LearnerKnowledgeGraph?> getLearnerGraph(String learnerId);
  Future<void> saveLearnerGraph(LearnerKnowledgeGraph graph);
  Future<LearnerNodeState?> getNodeState(String itemKey);
  Future<void> updateNodeState(LearnerNodeState state);
}

/// Abstract contract for Vocabulary Entry dictionary queries
abstract class VocabularyRepositoryContract {
  Future<VocabularyEntry?> getById(String id);
  Future<VocabularyEntry?> getByLemma(String lemma, String languageCode);
  Future<List<VocabularyEntry>> getDueReviews(DateTime currentTimestamp, {int limit = 20});
  Future<void> saveEntry(VocabularyEntry entry);
}

/// Abstract contract for Append-Only Event Store
abstract class EventStoreRepositoryContract {
  Future<void> appendEvent(DomainEvent event, List<int> serializedProtobuf);
  Stream<DomainEvent> readEvents({int startSequence = 0, String? aggregateIdFilter});
  Future<int> getLatestSequenceNumber();
}

/// Abstract contract for Settings & Platform Configuration persistence
abstract class SettingsRepositoryContract {
  Future<String?> getSetting(String key);
  Future<void> setSetting(String key, String value);
}
```
