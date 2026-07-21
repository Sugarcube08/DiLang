import 'package:equatable/equatable.dart';
import '../proficiency/cefr_level.dart';

enum FormalityLevel { informal, neutral, polite, formal, archaic }

class Phrase extends Equatable {
  final String id;
  final String text;
  final String intentCode; // e.g. "ORDER_FOOD"
  final FormalityLevel formality;
  final CefrLevel cefrLevel;
  final List<String> translations;
  final List<String> alternativePhrases;
  final List<String> commonLearnerErrors;

  const Phrase({
    required this.id,
    required this.text,
    required this.intentCode,
    required this.formality,
    required this.cefrLevel,
    required this.translations,
    this.alternativePhrases = const [],
    this.commonLearnerErrors = const [],
  });

  @override
  List<Object?> get props => [
        id,
        text,
        intentCode,
        formality,
        cefrLevel,
        translations,
        alternativePhrases,
        commonLearnerErrors,
      ];
}
