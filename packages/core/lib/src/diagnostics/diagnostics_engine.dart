import '../logger/logger_contract.dart';

class SystemMetrics {
  final DateTime timestamp;
  final int totalEventsProcessed;
  final int activePluginsCount;
  final List<String> registeredCapabilities;

  const SystemMetrics({
    required this.timestamp,
    required this.totalEventsProcessed,
    required this.activePluginsCount,
    required this.registeredCapabilities,
  });

  Map<String, dynamic> toMap() => {
        'timestamp': timestamp.toIso8601String(),
        'totalEventsProcessed': totalEventsProcessed,
        'activePluginsCount': activePluginsCount,
        'registeredCapabilities': registeredCapabilities,
      };
}

class DiagnosticsEngine {
  final LoggerContract? logger;

  DiagnosticsEngine({this.logger});

  SystemMetrics generateReport({
    required int totalEvents,
    required int activePlugins,
    required List<String> capabilities,
  }) {
    final metrics = SystemMetrics(
      timestamp: DateTime.now(),
      totalEventsProcessed: totalEvents,
      activePluginsCount: activePlugins,
      registeredCapabilities: capabilities,
    );

    logger?.info('Diagnostics Report Generated: ${metrics.toMap()}');
    return metrics;
  }
}
