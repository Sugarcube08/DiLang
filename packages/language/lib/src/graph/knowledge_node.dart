import 'package:equatable/equatable.dart';

enum KnowledgeNodeType {
  vocabulary,
  grammar,
  phrase,
  idiom,
  pronunciationRule,
  listeningPattern,
  readingPattern,
  writingPattern,
  conversationSkill,
  culturalNote,
  cefrObjective,
  assessmentObjective,
}

class KnowledgeNode extends Equatable {
  final String id;
  final String label;
  final KnowledgeNodeType type;
  final String cefrLevel;
  final Map<String, double> outgoingEdgeWeights; // targetNodeId -> weight
  final Map<String, dynamic> metadata;

  const KnowledgeNode({
    required this.id,
    required this.label,
    required this.type,
    required this.cefrLevel,
    this.outgoingEdgeWeights = const {},
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        id,
        label,
        type,
        cefrLevel,
        outgoingEdgeWeights,
        metadata,
      ];
}

class UniversalKnowledgeGraph {
  final Map<String, KnowledgeNode> _nodes = {};

  UniversalKnowledgeGraph({List<KnowledgeNode>? initialNodes}) {
    if (initialNodes != null) {
      for (final n in initialNodes) {
        _nodes[n.id] = n;
      }
    }
  }

  void addNode(KnowledgeNode node) {
    _nodes[node.id] = node;
  }

  KnowledgeNode? getNode(String id) => _nodes[id];

  List<KnowledgeNode> get allNodes => List.unmodifiable(_nodes.values);

  List<KnowledgeNode> findPrerequisitesFor(String nodeId) {
    final prerequisites = <KnowledgeNode>[];
    for (final node in _nodes.values) {
      if (node.outgoingEdgeWeights.containsKey(nodeId)) {
        prerequisites.add(node);
      }
    }
    return prerequisites;
  }

  static UniversalKnowledgeGraph createGermanA1Graph() {
    final graph = UniversalKnowledgeGraph();

    const nodeArticleDer = KnowledgeNode(
      id: 'node_art_der',
      label: 'Article "der" (Masculine Nominative/Accusative)',
      type: KnowledgeNodeType.grammar,
      cefrLevel: 'A1',
      outgoingEdgeWeights: {'node_acc_masc': 0.9},
    );

    const nodeAccMasc = KnowledgeNode(
      id: 'node_acc_masc',
      label: 'Accusative Masculine Article Inflection (der -> den)',
      type: KnowledgeNodeType.grammar,
      cefrLevel: 'A1',
      outgoingEdgeWeights: {'node_scn_cafe': 0.95},
    );

    const nodeScnCafe = KnowledgeNode(
      id: 'node_scn_cafe',
      label: 'Ordering at a Viennese Café Dialogue',
      type: KnowledgeNodeType.conversationSkill,
      cefrLevel: 'A1',
      outgoingEdgeWeights: {'node_obj_a1_3': 1.0},
    );

    const nodeObjA13 = KnowledgeNode(
      id: 'node_obj_a1_3',
      label: 'CEFR A1.3: Food & Drink Ordering Competency',
      type: KnowledgeNodeType.cefrObjective,
      cefrLevel: 'A1',
    );

    graph.addNode(nodeArticleDer);
    graph.addNode(nodeAccMasc);
    graph.addNode(nodeScnCafe);
    graph.addNode(nodeObjA13);

    return graph;
  }
}
