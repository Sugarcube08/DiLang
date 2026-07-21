import 'package:equatable/equatable.dart';

class RecommendationDiagnostic extends Equatable {
  final double predictedRetrievability;
  final double targetRetention;
  final double daysOverdue;
  final String reasoning;

  const RecommendationDiagnostic({
    required this.predictedRetrievability,
    required this.targetRetention,
    required this.daysOverdue,
    required this.reasoning,
  });

  @override
  List<Object?> get props => [
        predictedRetrievability,
        targetRetention,
        daysOverdue,
        reasoning,
      ];
}
