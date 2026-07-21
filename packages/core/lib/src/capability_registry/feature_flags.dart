enum CapabilityKey {
  offlineAiRuntime,
  cloudSyncEngine,
  diagnosticAssessment,
  speechSynthesis,
  phoneticAudio,
}

class CapabilityManifest {
  final CapabilityKey key;
  final bool isEnabled;
  final bool isExperimental;
  final String minSupportedVersion;

  const CapabilityManifest({
    required this.key,
    required this.isEnabled,
    this.isExperimental = false,
    required this.minSupportedVersion,
  });
}

class FeatureFlagRegistry {
  final Map<CapabilityKey, CapabilityManifest> _flags = {};

  FeatureFlagRegistry({List<CapabilityManifest>? initialFlags}) {
    final defaults = [
      const CapabilityManifest(
        key: CapabilityKey.offlineAiRuntime,
        isEnabled: true,
        minSupportedVersion: '2.0.0',
      ),
      const CapabilityManifest(
        key: CapabilityKey.cloudSyncEngine,
        isEnabled: true,
        minSupportedVersion: '2.0.0',
      ),
      const CapabilityManifest(
        key: CapabilityKey.diagnosticAssessment,
        isEnabled: true,
        minSupportedVersion: '2.0.0',
      ),
      const CapabilityManifest(
        key: CapabilityKey.speechSynthesis,
        isEnabled: true,
        minSupportedVersion: '2.0.0',
      ),
      const CapabilityManifest(
        key: CapabilityKey.phoneticAudio,
        isEnabled: true,
        minSupportedVersion: '2.0.0',
      ),
    ];

    for (final flag in initialFlags ?? defaults) {
      _flags[flag.key] = flag;
    }
  }

  bool isEnabled(CapabilityKey key) {
    return _flags[key]?.isEnabled ?? false;
  }

  void setEnabled(CapabilityKey key, bool enabled) {
    final existing = _flags[key];
    if (existing != null) {
      _flags[key] = CapabilityManifest(
        key: existing.key,
        isEnabled: enabled,
        isExperimental: existing.isExperimental,
        minSupportedVersion: existing.minSupportedVersion,
      );
    }
  }
}
