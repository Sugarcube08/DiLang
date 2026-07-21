import 'package:equatable/equatable.dart';

class PluginManifest extends Equatable {
  final String id;
  final String version;
  final String name;
  final List<String> capabilities;
  final List<String> platforms;
  final List<String> dependencies;
  final int priority;

  const PluginManifest({
    required this.id,
    required this.version,
    required this.name,
    required this.capabilities,
    required this.platforms,
    required this.dependencies,
    this.priority = 0,
  });

  factory PluginManifest.fromMap(Map<String, dynamic> map) {
    return PluginManifest(
      id: map['id'] as String,
      version: map['version'] as String,
      name: map['name'] as String? ?? map['id'] as String,
      capabilities: List<String>.from((map['capabilities'] as Iterable?) ?? const []),
      platforms: List<String>.from((map['platforms'] as Iterable?) ?? const []),
      dependencies: List<String>.from((map['dependencies'] as Iterable?) ?? const []),
      priority: map['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'version': version,
        'name': name,
        'capabilities': capabilities,
        'platforms': platforms,
        'dependencies': dependencies,
        'priority': priority,
      };

  @override
  List<Object?> get props => [
        id,
        version,
        name,
        capabilities,
        platforms,
        dependencies,
        priority,
      ];
}
