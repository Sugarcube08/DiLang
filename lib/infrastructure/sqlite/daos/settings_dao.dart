import 'package:sqlite3/sqlite3.dart';

class SettingsDao {
  final Database db;

  const SettingsDao(this.db);

  void setSetting(String key, String value, int updatedAt) {
    db.execute(
      'INSERT INTO settings (key, value, updated_at) VALUES (?, ?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value, updated_at = excluded.updated_at;',
      [key, value, updatedAt],
    );
  }

  String? getSetting(String key) {
    final res = db.select('SELECT value FROM settings WHERE key = ?;', [key]);
    if (res.isEmpty) return null;
    return res.first['value'] as String?;
  }
}
