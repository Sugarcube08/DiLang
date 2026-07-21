import 'package:equatable/equatable.dart';

class UxPerformanceKpiReport extends Equatable {
  final double coldBootLatencyMs;
  final double screenTransitionMs;
  final double aiResponseLatencyMs;
  final double sessionCompletionRate;

  const UxPerformanceKpiReport({
    required this.coldBootLatencyMs,
    required this.screenTransitionMs,
    required this.aiResponseLatencyMs,
    required this.sessionCompletionRate,
  });

  bool passesKpiThresholds() {
    return coldBootLatencyMs < 500.0 &&
        screenTransitionMs < 150.0 &&
        aiResponseLatencyMs < 2000.0 &&
        sessionCompletionRate >= 0.80;
  }

  @override
  List<Object?> get props => [
        coldBootLatencyMs,
        screenTransitionMs,
        aiResponseLatencyMs,
        sessionCompletionRate,
      ];
}
