abstract class VocabularyRepository {
  Future<Map<String, dynamic>?> lookup(String term);
}

class VocabularyRepositoryImpl implements VocabularyRepository {
  @override
  Future<Map<String, dynamic>?> lookup(String term) async {
    return {
      'term': term,
      'cefr_level': 'A1',
      'definition': 'Sample definition for $term',
    };
  }
}
