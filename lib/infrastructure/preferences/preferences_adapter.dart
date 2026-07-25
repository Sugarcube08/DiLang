abstract class PreferencesAdapter {
  Future<void> initialize();
  String? getString(String key);
  Future<bool> setString(String key, String value);
  Future<void> dispose();
}

class MemoryPreferencesAdapter implements PreferencesAdapter {
  final Map<String, String> _store = {};

  @override
  Future<void> initialize() async {}

  @override
  String? getString(String key) => _store[key];

  @override
  Future<bool> setString(String key, String value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<void> dispose() async {
    _store.clear();
  }
}
