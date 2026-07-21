import 'package:equatable/equatable.dart';

enum PhonemeType { vowel, consonant, diphthong, tone }

class PhonemeUnit extends Equatable {
  final String ipaSymbol;
  final PhonemeType type;
  final String description;
  final List<String> exampleWords;

  const PhonemeUnit({
    required this.ipaSymbol,
    required this.type,
    required this.description,
    required this.exampleWords,
  });

  @override
  List<Object?> get props => [ipaSymbol, type, description, exampleWords];
}
