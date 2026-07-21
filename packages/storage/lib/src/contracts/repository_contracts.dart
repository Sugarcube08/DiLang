import 'package:dilang_core/core.dart';
import 'package:dilang_language/language.dart';
import 'package:dilang_learner/learner.dart';

abstract class LearnerRepositoryContract {
  Future<LearnerKnowledgeGraph?> getLearnerGraph(String learnerId);
  Future<void> saveLearnerGraph(LearnerKnowledgeGraph graph);
  Future<LearnerNodeState?> getNodeState(String itemKey);
  Future<void> updateNodeState(LearnerNodeState state);
}

abstract class VocabularyRepositoryContract {
  Future<VocabularyEntry?> getById(String id);
  Future<VocabularyEntry?> getByLemma(String lemma, String languageCode);
  Future<List<VocabularyEntry>> getDueReviews(DateTime currentTimestamp, {int limit = 20});
  Future<void> saveEntry(VocabularyEntry entry);
}

abstract class EventStoreRepositoryContract {
  Future<void> appendEvent(DomainEvent event, List<int> serializedProtobuf);
  Stream<DomainEvent> readEvents({int startSequence = 0, String? aggregateIdFilter});
  Future<int> getLatestSequenceNumber();
}

abstract class SettingsRepositoryContract {
  Future<String?> getSetting(String key);
  Future<void> setSetting(String key, String value);
}
