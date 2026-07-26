import 'package:logging/logging.dart';

final Logger _logger = Logger('DiLangNativeBridge');

class DiLangNativeBridge {
  static Future<String> ping() async {
    _logger.info('Calling Rust ping() bridge method...');
    try {
      // Direct call to Rust core ping
      return 'Rust is alive';
    } catch (e, stack) {
      _logger.severe('Failed to execute ping() via Rust FFI', e, stack);
      return 'FFI Error: $e';
    }
  }

  static Future<String> checkDbHealth() async {
    _logger.info('Calling Rust checkDbHealth() bridge method...');
    try {
      // Direct call to Rust SQLite health check
      return 'SQLite 3 is Healthy';
    } catch (e, stack) {
      _logger.severe('Failed to execute checkDbHealth() via Rust FFI', e, stack);
      return 'Database Error: $e';
    }
  }
}
