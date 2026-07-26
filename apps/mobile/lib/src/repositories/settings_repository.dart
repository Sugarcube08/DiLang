abstract class SettingsRepository {
  Future<Map<String, dynamic>> loadSettings();
}

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Map<String, dynamic>> loadSettings() async {
    return {
      'theme_mode': 'dark',
      'offline_mode': true,
    };
  }
}
