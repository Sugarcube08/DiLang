import 'package:equatable/equatable.dart';

class SurfaceForm extends Equatable {
  final String text;
  final String grammaticalTag; // e.g. "plural", "past_tense", "dative_singular"
  final String? ipa;

  const SurfaceForm({
    required this.text,
    required this.grammaticalTag,
    this.ipa,
  });

  @override
  List<Object?> get props => [text, grammaticalTag, ipa];
}
