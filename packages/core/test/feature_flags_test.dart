import 'package:test/test.dart';
import 'package:dilang_core/core.dart';

void main() {
  group('FeatureFlagRegistry Tests', () {
    test('Default capabilities are registered and enabled', () {
      final registry = FeatureFlagRegistry();
      expect(registry.isEnabled(CapabilityKey.offlineAiRuntime), isTrue);
      expect(registry.isEnabled(CapabilityKey.cloudSyncEngine), isTrue);
      expect(registry.isEnabled(CapabilityKey.diagnosticAssessment), isTrue);
    });

    test('Capability can be disabled or toggled', () {
      final registry = FeatureFlagRegistry();
      registry.setEnabled(CapabilityKey.cloudSyncEngine, false);
      expect(registry.isEnabled(CapabilityKey.cloudSyncEngine), isFalse);
      expect(registry.isEnabled(CapabilityKey.offlineAiRuntime), isTrue);
    });
  });
}
