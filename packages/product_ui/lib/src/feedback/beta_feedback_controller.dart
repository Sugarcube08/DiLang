import 'package:equatable/equatable.dart';

class BetaFeedbackReport extends Equatable {
  final String reportId;
  final String feedbackText;
  final bool hasScreenshotAttached;
  final String logsPayload;
  final DateTime timestamp;

  const BetaFeedbackReport({
    required this.reportId,
    required this.feedbackText,
    this.hasScreenshotAttached = false,
    this.logsPayload = '',
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        reportId,
        feedbackText,
        hasScreenshotAttached,
        logsPayload,
        timestamp,
      ];
}

class BetaFeedbackController {
  final List<BetaFeedbackReport> submittedReports = [];

  BetaFeedbackReport submitFeedback({
    required String feedbackText,
    bool hasScreenshot = false,
    String logs = '',
  }) {
    final report = BetaFeedbackReport(
      reportId: 'feedback_${DateTime.now().millisecondsSinceEpoch}',
      feedbackText: feedbackText,
      hasScreenshotAttached: hasScreenshot,
      logsPayload: logs,
      timestamp: DateTime.now(),
    );

    submittedReports.add(report);
    return report;
  }
}
