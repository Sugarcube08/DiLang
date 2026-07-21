import 'module_lifecycle.dart';
import '../logger/logger_contract.dart';

class LifecycleManager {
  final LoggerContract? logger;
  final List<ModuleLifecycle> _registeredModules = [];

  LifecycleManager({this.logger});

  List<ModuleLifecycle> get registeredModules => List.unmodifiable(_registeredModules);

  void registerModule(ModuleLifecycle module) {
    if (_registeredModules.any((m) => m.moduleId == module.moduleId)) {
      logger?.warning('Module [${module.moduleId}] is already registered in LifecycleManager');
      return;
    }
    _registeredModules.add(module);
    logger?.info('Registered module [${module.moduleId}] in LifecycleManager');
  }

  Future<void> initializeAll() async {
    logger?.info('Initializing all registered modules...');
    for (final module in _registeredModules) {
      if (module.state == ModuleState.uninitialized) {
        logger?.debug('Initializing [${module.moduleId}]');
        await module.initialize();
      }
    }
  }

  Future<void> startAll() async {
    logger?.info('Starting all registered modules...');
    for (final module in _registeredModules) {
      if (module.state == ModuleState.initialized || module.state == ModuleState.stopped) {
        logger?.debug('Starting [${module.moduleId}]');
        await module.start();
      }
    }
  }

  Future<void> pauseAll() async {
    logger?.info('Pausing all running modules...');
    for (final module in _registeredModules) {
      if (module.state == ModuleState.running) {
        await module.pause();
      }
    }
  }

  Future<void> resumeAll() async {
    logger?.info('Resuming all paused modules...');
    for (final module in _registeredModules) {
      if (module.state == ModuleState.paused) {
        await module.resume();
      }
    }
  }

  Future<void> stopAll() async {
    logger?.info('Stopping all running modules...');
    for (final module in _registeredModules.reversed) {
      if (module.state == ModuleState.running || module.state == ModuleState.paused) {
        await module.stop();
      }
    }
  }

  Future<void> disposeAll() async {
    logger?.info('Disposing all registered modules...');
    for (final module in _registeredModules.reversed) {
      if (module.state != ModuleState.disposed) {
        await module.dispose();
      }
    }
    _registeredModules.clear();
  }
}
