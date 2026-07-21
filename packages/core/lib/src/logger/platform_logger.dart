import 'logger_contract.dart';

typedef LogPrinter = void Function(LogLevel level, String message, Object? error, StackTrace? stackTrace);

class PlatformLogger implements LoggerContract {
  final LogLevel minLevel;
  final LogPrinter? customPrinter;
  final List<String> _logs = [];

  PlatformLogger({
    this.minLevel = LogLevel.debug,
    this.customPrinter,
  });

  List<String> get logs => List.unmodifiable(_logs);

  void _log(LogLevel level, String message, Object? error, StackTrace? stackTrace) {
    if (level.index < minLevel.index) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final formatted = '[$timestamp] [${level.name.toUpperCase()}] $message${error != null ? ' | Error: $error' : ''}';
    _logs.add(formatted);

    if (customPrinter != null) {
      customPrinter!(level, message, error, stackTrace);
    } else {
      // Standard console output for pure Dart
      print(formatted);
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
  }

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.debug, message, error, stackTrace);

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.info, message, error, stackTrace);

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.warning, message, error, stackTrace);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);

  @override
  void fatal(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.fatal, message, error, stackTrace);
}
