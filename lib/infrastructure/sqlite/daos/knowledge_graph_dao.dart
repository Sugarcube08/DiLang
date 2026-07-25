import 'package:sqlite3/sqlite3.dart';

class KnowledgeGraphDao {
  final Database db;

  const KnowledgeGraphDao(this.db);

  void insertNode({
    required String nodeId,
    required String word,
    required String targetLanguage,
    required String cefrLevel,
    required double masteryScore,
  }) {
    db.execute(
      'INSERT INTO knowledge_nodes (node_id, word, target_language, cefr_level, mastery_score) VALUES (?, ?, ?, ?, ?);',
      [nodeId, word, targetLanguage, cefrLevel, masteryScore],
    );
  }

  void insertEdge({
    required String edgeId,
    required String sourceNodeId,
    required String targetNodeId,
    required String relationType,
    required double weight,
  }) {
    db.execute(
      'INSERT INTO knowledge_edges (edge_id, source_node_id, target_node_id, relation_type, weight) VALUES (?, ?, ?, ?, ?);',
      [edgeId, sourceNodeId, targetNodeId, relationType, weight],
    );
  }

  ResultSet fetchNodesForLanguage(String targetLanguage) {
    return db.select('SELECT node_id, word, cefr_level, mastery_score FROM knowledge_nodes WHERE target_language = ?;', [targetLanguage]);
  }
}
