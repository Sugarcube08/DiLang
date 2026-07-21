import 'package:equatable/equatable.dart';

class LanguagePackManifest extends Equatable {
  final String packId;
  final String targetLanguage;
  final String version;
  final int totalVocabularyEntries;
  final int totalGrammarRules;

  const LanguagePackManifest({
    required this.packId,
    required this.targetLanguage,
    required this.version,
    required this.totalVocabularyEntries,
    required this.totalGrammarRules,
  });

  bool isValid() {
    return packId.isNotEmpty &&
        targetLanguage.isNotEmpty &&
        totalVocabularyEntries > 0 &&
        totalGrammarRules > 0;
  }

  @override
  List<Object?> get props => [
        packId,
        targetLanguage,
        version,
        totalVocabularyEntries,
        totalGrammarRules,
      ];
}

class LanguagePackValidator {
  bool validateManifest(LanguagePackManifest manifest) {
    return manifest.isValid();
  }
}
