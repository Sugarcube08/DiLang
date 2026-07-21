import 'plugin_manifest.dart';
import '../lifecycle/module_lifecycle.dart';

abstract class PluginContract implements ModuleLifecycle {
  PluginManifest get manifest;

  @override
  String get moduleId => manifest.id;
}
