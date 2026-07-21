import 'package:equatable/equatable.dart';

enum SemanticRelationType { synonym, antonym, hypernym, hyponym, collocation }

class SemanticRelation extends Equatable {
  final String targetLemmaId;
  final SemanticRelationType relationType;
  final double strength; // 0.0 to 1.0

  const SemanticRelation({
    required this.targetLemmaId,
    required this.relationType,
    this.strength = 1.0,
  });

  @override
  List<Object?> get props => [targetLemmaId, relationType, strength];
}
