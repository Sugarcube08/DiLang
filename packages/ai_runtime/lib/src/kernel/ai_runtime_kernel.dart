import 'package:dilang_core/core.dart';
import '../model_manager/model_registry.dart';
import '../resource_scheduler/resource_scheduler.dart';

class AiRuntimeKernel implements ModuleLifecycle {
  final ModelRegistry modelRegistry;
  final ResourceScheduler resourceScheduler;
  ModuleState _state = ModuleState.uninitialized;

  AiRuntimeKernel({
    ModelRegistry? modelRegistry,
    ResourceScheduler? resourceScheduler,
  })  : modelRegistry = modelRegistry ?? ModelRegistry(),
        resourceScheduler = resourceScheduler ?? ResourceScheduler();

  @override
  String get moduleId => 'dilang.ai_runtime.kernel';

  @override
  ModuleState get state => _state;

  @override
  Future<void> initialize() async {
    _state = ModuleState.initialized;
  }

  @override
  Future<void> start() async {
    _state = ModuleState.running;
  }

  @override
  Future<void> pause() async {
    _state = ModuleState.paused;
  }

  @override
  Future<void> resume() async {
    _state = ModuleState.running;
  }

  @override
  Future<void> stop() async {
    _state = ModuleState.stopped;
  }

  @override
  Future<void> dispose() async {
    _state = ModuleState.disposed;
  }
}
