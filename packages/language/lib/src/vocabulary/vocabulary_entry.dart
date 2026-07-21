import 'package:equatable/equatable.dart';
import 'lemma.dart';
import 'surface_form.dart';
import 'semantic_relation.dart';
import '../proficiency/cefr_level.dart';

class VocabularyEntry extends Equatable {
  final String id;
  final Lemma lemma;
  final List<SurfaceForm> surfaceForms;
  final List<String> translations;
  final List<String> exampleSentences;
  final CefrLevel cefrLevel;
  final int frequencyRank; // Lower number = more frequent
  final List<SemanticRelation> relations;

  const VocabularyEntry({
    required this.id,
    required this.lemma,
    required this.surfaceForms,
    required this.translations,
    required this.exampleSentences,
    required this.cefrLevel,
    required this.frequencyRank,
    this.relations = const [],
  });

  @override
  List<Object?> get props => [
        id,
        lemma,
        surfaceForms,
        translations,
        exampleSentences,
        cefrLevel,
        frequencyRank,
        relations,
      ];
}
