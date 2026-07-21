import 'package:test/test.dart';
import 'package:dilang_design_system/design_system.dart';

void main() {
  group('Design System Tokens Tests', () {
    test('1. ColorPalette exposes dark mode tokens', () {
      expect(ColorPalette.backgroundHex, equals('#0B0F19'));
      expect(ColorPalette.accentHex, equals('#38BDF8'));
    });
  });
}
