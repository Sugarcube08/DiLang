import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/vocabulary_repository.dart';

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepositoryImpl();
});

class VocabularyNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final VocabularyRepository _repository;

  VocabularyNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> lookup(String term) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.lookup(term));
  }
}

final vocabularyProvider = StateNotifierProvider<VocabularyNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final repo = ref.watch(vocabularyRepositoryProvider);
  return VocabularyNotifier(repo);
});
