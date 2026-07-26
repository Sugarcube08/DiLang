abstract class GrammarRepository {
  Future<List<String>> getConcepts();
}

class GrammarRepositoryImpl implements GrammarRepository {
  @override
  Future<List<String>> getConcepts() async {
    return ['Present Simple', 'Subject-Verb Agreement'];
  }
}
