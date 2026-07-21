import 'package:equatable/equatable.dart';

enum AdaptationStrategy { conservative, balanced, accelerated }

class LearningPolicy extends Equatable {
  final String policyVersion;
  final int maxNewItemsPerDay;
  final int maxReviewQueueLoad;
  final double targetRetentionThreshold; // e.g. 0.90
  final AdaptationStrategy adaptationStrategy;
  final double cefrPromotionThreshold; // e.g. 0.85

  const LearningPolicy({
    this.policyVersion = '1.0.0',
    this.maxNewItemsPerDay = 15,
    this.maxReviewQueueLoad = 100,
    this.targetRetentionThreshold = 0.90,
    this.adaptationStrategy = AdaptationStrategy.balanced,
    this.cefrPromotionThreshold = 0.85,
  });

  @override
  List<Object?> get props => [
        policyVersion,
        maxNewItemsPerDay,
        maxReviewQueueLoad,
        targetRetentionThreshold,
        adaptationStrategy,
        cefrPromotionThreshold,
      ];
}
