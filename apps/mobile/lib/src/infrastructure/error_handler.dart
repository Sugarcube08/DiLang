import 'package:logging/logging.dart';

final Logger _logger = Logger('GlobalErrorHandler');

class AppErrorPayload {
  final int code;
  final String userMessage;
  final String devContext;

  const AppErrorPayload({
    required this.code,
    required this.userMessage,
    required this.devContext,
  });
}

class GlobalErrorHandler {
  static void handle(Object error, StackTrace? stack) {
    _logger.severe('Unhandled Application Error: $error', error, stack);
  }
}
