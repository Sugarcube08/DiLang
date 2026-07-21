import 'dart:async';
import 'package:dilang_core/core.dart';
import 'package:dilang_language/language.dart';
import 'package:dilang_learner/learner.dart';
import '../contracts/repository_contracts.dart';

class InMemoryLearnerRepository implements LearnerRepositoryContract {
  final Map<String, LearnerKnowledgeGraph> _graphs = {};

  @override
  Future<LearnerKnowledgeGraph?> getLearnerGraph(String learnerId) async {
    return _graphs[learnerId];
  }

  @override
  Future<void> saveLearnerGraph(LearnerKnowledgeGraph graph) async {
    _graphs[graph.learnerId] = graph;
  }

  @override
  Future<LearnerNodeState?> getNodeState(String itemKey) async {
    for (final g in _graphs.values) {
      if (g.nodeStates.containsKey(itemKey)) {
        return g.nodeStates[itemKey];
      }
    }
    return null;
  }

  @override
  Future<void> updateNodeState(LearnerNodeState state) async {
    // No-op for in-memory mock update
  }
}

class InMemoryVocabularyRepository implements VocabularyRepositoryContract {
  final Map<String, VocabularyEntry> _entries = {};

  @override
  Future<VocabularyEntry?> getById(String id) async => _entries[id];

  @override
  Future<VocabularyEntry?> getByLemma(String lemma, String languageCode) async {
    return _entries.values.cast<VocabularyEntry?>().firstWhere(
          (e) => e != null && e.lemma.text == lemma && e.lemma.languageCode == languageCode,
          orElse: () => null,
        );
  }

  @override
  Future<List<VocabularyEntry>> getDueReviews(DateTime currentTimestamp, {int limit = 20}) async {
    return _entries.values.take(limit).toList();
  }

  @override
  Future<void> saveEntry(VocabularyEntry entry) async {
    _entries[entry.id] = entry;
  }
}

class InMemoryEventStoreRepository implements EventStoreRepositoryContract {
  final List<DomainEvent> _events = [];

  @override
  Future<void> appendEvent(DomainEvent event, List<int> serializedProtobuf) async {
    _events.add(event);
  }

  @override
  Stream<DomainEvent> readEvents({int startSequence = 0, String? aggregateIdFilter}) async* {
    for (var i = startSequence; i < _events.length; i++) {
      final ev = _events[i];
      if (aggregateIdFilter == null || ev.aggregateId == aggregateIdFilter) {
        yield ev;
      }
    }
  }

  @override
  Future<int> getLatestSequenceNumber() async => _events.length;
}
