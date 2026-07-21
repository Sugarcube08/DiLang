import 'package:test/test.dart';
import 'package:dilang_design_system/design_system.dart';

void main() {
  group('Design System Tokens & Brand Experience System Tests', () {
    test('1. ColorPalette exposes dark mode tokens', () {
      expect(ColorPalette.backgroundHex, equals('#0B0F19'));
      expect(ColorPalette.accentHex, equals('#38BDF8'));
    });

    test('2. BrandTokens exposes psychological color palette tokens', () {
      expect(BrandTokens.backgroundNavy, equals('#0B1020'));
      expect(BrandTokens.surfaceSlate, equals('#172033'));
      expect(BrandTokens.primaryAzure, equals('#3B82F6'));
      expect(BrandTokens.secondaryCyan, equals('#22D3EE'));
      expect(BrandTokens.successEmerald, equals('#22C55E'));
      expect(BrandTokens.warningAmber, equals('#F59E0B'));
      expect(BrandTokens.errorCoralRed, equals('#EF4444'));
      expect(BrandTokens.accentViolet, equals('#8B5CF6'));
    });

    test('3. VoiceVisualizerModel transitions state and audio amplitude', () {
      const visualizer = VoiceVisualizerModel();
      expect(visualizer.state, equals(VoiceVisualizerState.idle));

      final activeVisualizer = visualizer.copyWith(
        state: VoiceVisualizerState.speaking,
        audioAmplitude: 0.85,
      );

      expect(activeVisualizer.state, equals(VoiceVisualizerState.speaking));
      expect(activeVisualizer.audioAmplitude, equals(0.85));
    });
  });
}
