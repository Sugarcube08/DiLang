import 'package:dilang_core/core.dart';
import 'package:dilang_learner/learner.dart';
import 'package:dilang_memory/memory.dart';
import '../policies/learning_policy.dart';
import '../recommendation/recommendation_engine.dart';

class LearningEngineOrchestrator implements ModuleLifecycle {
  final LearningPolicy policy;
  final RecommendationEngine recommendationEngine;
  ModuleState _state = ModuleState.uninitialized;

  LearningEngineOrchestrator({
    this.policy = const LearningPolicy(),
    this.recommendationEngine = const RecommendationEngine(),
  });

  @override
  String get moduleId => 'dilang.learning_engine.orchestrator';

  @override
  ModuleState get state => _state;

  List<LearningRecommendation> evaluateNextSession({
    required LearnerKnowledgeGraph graph,
    required Map<String, FsrsItemState> fsrsStates,
    required DateTime currentTimestamp,
  }) {
    return recommendationEngine.generateRecommendations(
      graph: graph,
      fsrsStates: fsrsStates,
      policy: policy,
      currentTimestamp: currentTimestamp,
    );
  }

  @override
  Future<void> initialize() async => _state = ModuleState.initialized;

  @override
  Future<void> start() async => _state = ModuleState.running;

  @override
  Future<void> pause() async => _state = ModuleState.paused;

  @override
  Future<void> resume() async => _state = ModuleState.running;

  @override
  Future<void> stop() async => _state = ModuleState.stopped;

  @override
  Future<void> dispose() async => _state = ModuleState.disposed;
}
