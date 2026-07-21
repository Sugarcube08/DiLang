import '../logger/logger_contract.dart';
import '../errors/platform_exceptions.dart';

class CapabilityRegistry {
  static final CapabilityRegistry _instance = CapabilityRegistry._internal();
  static CapabilityRegistry get instance => _instance;

  final Map<Type, Object> _registry = {};
  LoggerContract? logger;

  CapabilityRegistry._internal();

  factory CapabilityRegistry({LoggerContract? logger}) {
    if (logger != null) {
      _instance.logger = logger;
    }
    return _instance;
  }

  void register<T extends Object>(T implementation) {
    if (_registry.containsKey(T)) {
      logger?.warning('Overwriting Capability registration for type [$T]');
    }
    _registry[T] = implementation;
    logger?.info('Capability registered: [$T]');
  }

  T resolve<T extends Object>() {
    final impl = _registry[T];
    if (impl == null) {
      final error = ConfigurationException('Capability type [$T] is not registered in CapabilityRegistry');
      logger?.error(error.message);
      throw error;
    }
    return impl as T;
  }

  bool isRegistered<T extends Object>() => _registry.containsKey(T);

  void unregister<T extends Object>() {
    _registry.remove(T);
    logger?.info('Unregistered Capability: [$T]');
  }

  void reset() {
    _registry.clear();
  }
}
