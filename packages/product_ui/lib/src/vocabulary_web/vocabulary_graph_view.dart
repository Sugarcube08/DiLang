import 'package:equatable/equatable.dart';

class VocabularyNode extends Equatable {
  final String id;
  final String word;
  final String translation;
  final String ipaPronunciation;
  final String category;
  final double fsrsStabilityDays;
  final double retrievability;

  const VocabularyNode({
    required this.id,
    required this.word,
    required this.translation,
    required this.ipaPronunciation,
    required this.category,
    required this.fsrsStabilityDays,
    required this.retrievability,
  });

  @override
  List<Object?> get props => [
        id,
        word,
        translation,
        ipaPronunciation,
        category,
        fsrsStabilityDays,
        retrievability,
      ];
}

class VocabularyEdge extends Equatable {
  final String sourceNodeId;
  final String targetNodeId;
  final String relationshipType; // e.g. 'category', 'synonym', 'context'

  const VocabularyEdge({
    required this.sourceNodeId,
    required this.targetNodeId,
    required this.relationshipType,
  });

  @override
  List<Object?> get props => [sourceNodeId, targetNodeId, relationshipType];
}

class VocabularyKnowledgeGraph extends Equatable {
  final List<VocabularyNode> nodes;
  final List<VocabularyEdge> edges;

  const VocabularyKnowledgeGraph({
    this.nodes = const [],
    this.edges = const [],
  });

  static VocabularyKnowledgeGraph sampleFoodGraph() {
    const n1 = VocabularyNode(
      id: 'food_1',
      word: 'Essen',
      translation: 'Food',
      ipaPronunciation: '/ˈɛsən/',
      category: 'Food',
      fsrsStabilityDays: 14.5,
      retrievability: 0.96,
    );
    const n2 = VocabularyNode(
      id: 'food_2',
      word: 'Restaurant',
      translation: 'Restaurant',
      ipaPronunciation: '/rɛstoˈʁɑ̃ː/',
      category: 'Dining',
      fsrsStabilityDays: 8.2,
      retrievability: 0.91,
    );
    const n3 = VocabularyNode(
      id: 'food_3',
      word: 'Kochen',
      translation: 'Cooking',
      ipaPronunciation: '/ˈkɔxn̩/',
      category: 'Activity',
      fsrsStabilityDays: 11.0,
      retrievability: 0.94,
    );
    const n4 = VocabularyNode(
      id: 'food_4',
      word: 'Küche',
      translation: 'Kitchen',
      ipaPronunciation: '/ˈkʏçə/',
      category: 'Home',
      fsrsStabilityDays: 18.0,
      retrievability: 0.98,
    );

    return const VocabularyKnowledgeGraph(
      nodes: [n1, n2, n3, n4],
      edges: [
        VocabularyEdge(sourceNodeId: 'food_1', targetNodeId: 'food_2', relationshipType: 'context'),
        VocabularyEdge(sourceNodeId: 'food_1', targetNodeId: 'food_3', relationshipType: 'activity'),
        VocabularyEdge(sourceNodeId: 'food_3', targetNodeId: 'food_4', relationshipType: 'location'),
      ],
    );
  }

  @override
  List<Object?> get props => [nodes, edges];
}
