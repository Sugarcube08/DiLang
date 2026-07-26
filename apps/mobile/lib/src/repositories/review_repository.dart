abstract class ReviewRepository {
  Future<Map<String, dynamic>?> nextCard();
  Future<void> submitRating(String cardId, int rating);
}

class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<Map<String, dynamic>?> nextCard() async {
    return {
      'id': 'card-1',
      'term': 'Bonjour',
      'due': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<void> submitRating(String cardId, int rating) async {}
}
