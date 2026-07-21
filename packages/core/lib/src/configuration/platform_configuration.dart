import '../errors/platform_exceptions.dart';

class PlatformConfiguration {
  final Map<String, dynamic> _configValues;

  const PlatformConfiguration(this._configValues);

  factory PlatformConfiguration.empty() => const PlatformConfiguration({});

  factory PlatformConfiguration.fromMap(Map<String, dynamic> map) => PlatformConfiguration(map);

  T get<T>(String key) {
    final value = _configValues[key];
    if (value == null) {
      throw ConfigurationException(key);
    }
    return value as T;
  }

  T getOrDefault<T>(String key, T defaultValue) {
    final value = _configValues[key];
    if (value == null) return defaultValue;
    return value as T;
  }

  bool hasKey(String key) => _configValues.containsKey(key);
}
