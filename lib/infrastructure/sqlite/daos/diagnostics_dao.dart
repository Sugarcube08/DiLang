import 'package:sqlite3/sqlite3.dart';

class DiagnosticsDao {
  final Database db;

  const DiagnosticsDao(this.db);

  void insertLog({
    required String logId,
    required String level,
    required String message,
    required String module,
    required int timestamp,
  }) {
    db.execute(
      'INSERT INTO runtime_logs (log_id, level, message, module, timestamp) VALUES (?, ?, ?, ?, ?);',
      [logId, level, message, module, timestamp],
    );
  }

  void insertMetric({
    required String metricId,
    required String name,
    required double value,
    required int timestamp,
  }) {
    db.execute(
      'INSERT INTO performance_metrics (metric_id, name, value, timestamp) VALUES (?, ?, ?, ?);',
      [metricId, name, value, timestamp],
    );
  }

  ResultSet fetchRecentLogs(int limit) {
    return db.select('SELECT log_id, level, message, module, timestamp FROM runtime_logs ORDER BY timestamp DESC LIMIT ?;', [limit]);
  }
}
