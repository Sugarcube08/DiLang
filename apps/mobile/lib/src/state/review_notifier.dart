import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/review_repository.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl();
});

class ReviewNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ReviewRepository _repository;

  ReviewNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> fetchNext() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.nextCard());
  }
}

final reviewProvider = StateNotifierProvider<ReviewNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final repo = ref.watch(reviewRepositoryProvider);
  return ReviewNotifier(repo);
});
