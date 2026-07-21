import 'package:test/test.dart';
import 'package:dilang_product_ui/product_ui.dart';

void main() {
  group('Product UI State & Component Tests', () {
    test('1. DashboardUiState initializes with default values', () {
      const state = DashboardUiState();
      expect(state.recommendations, isEmpty);
      expect(state.isLoading, isFalse);
    });
  });
}
