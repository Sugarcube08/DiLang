import 'plugin_contract.dart';
import '../logger/logger_contract.dart';
import '../errors/platform_exceptions.dart';

class PluginManager {
  final LoggerContract? logger;
  final Map<String, PluginContract> _plugins = {};

  PluginManager({this.logger});

  List<PluginContract> get registeredPlugins =>
      List.unmodifiable(_plugins.values.toList()..sort((a, b) => b.manifest.priority.compareTo(a.manifest.priority)));

  void registerPlugin(PluginContract plugin) {
    final manifest = plugin.manifest;

    // Validate manifest
    if (manifest.id.isEmpty || manifest.version.isEmpty) {
      throw const ManifestInvalidException('Plugin ID and version must not be empty');
    }

    // Check dependencies
    for (final dep in manifest.dependencies) {
      if (!_plugins.containsKey(dep)) {
        throw PluginDependencyMissingException(manifest.id, dep);
      }
    }

    _plugins[manifest.id] = plugin;
    logger?.info('Registered plugin [${manifest.id}] (Priority: ${manifest.priority})');
  }

  PluginContract? getPlugin(String pluginId) => _plugins[pluginId];

  bool isCapabilitySupported(String capability) {
    return _plugins.values.any((p) => p.manifest.capabilities.contains(capability));
  }
}
