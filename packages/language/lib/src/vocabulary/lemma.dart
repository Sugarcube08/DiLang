import 'package:equatable/equatable.dart';

enum PartOfSpeech {
  noun,
  verb,
  adjective,
  adverb,
  pronoun,
  preposition,
  conjunction,
  interjection,
  particle,
  idiom
}

class Lemma extends Equatable {
  final String id;
  final String text;
  final PartOfSpeech partOfSpeech;
  final String languageCode;
  final String? ipaTranscription;

  const Lemma({
    required this.id,
    required this.text,
    required this.partOfSpeech,
    required this.languageCode,
    this.ipaTranscription,
  });

  @override
  List<Object?> get props => [id, text, partOfSpeech, languageCode, ipaTranscription];
}
