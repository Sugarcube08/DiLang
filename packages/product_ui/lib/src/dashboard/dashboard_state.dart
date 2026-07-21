import 'package:equatable/equatable.dart';
import 'package:dilang_learning_engine/learning_engine.dart';

class DashboardUiState extends Equatable {
  final List<LearningRecommendation> recommendations;
  final double averageRetention;
  final bool isLoading;

  const DashboardUiState({
    this.recommendations = const [],
    this.averageRetention = 0.0,
    this.isLoading = false,
  });

  DashboardUiState copyWith({
    List<LearningRecommendation>? recommendations,
    double? averageRetention,
    bool? isLoading,
  }) {
    return DashboardUiState(
      recommendations: recommendations ?? this.recommendations,
      averageRetention: averageRetention ?? this.averageRetention,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [recommendations, averageRetention, isLoading];
}
