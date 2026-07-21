import 'package:equatable/equatable.dart';

/// Base Exception class for all DiLang system errors.
abstract class PlatformException extends Equatable implements Exception {
  final String message;
  final String? errorCode;
  final Object? cause;
  final StackTrace? stackTrace;

  const PlatformException(
    this.message, {
    this.errorCode,
    this.cause,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, errorCode, cause];

  @override
  String toString() => '$runtimeType: $message${errorCode != null ? ' [$errorCode]' : ''}';
}

// -----------------------------------------------------------------------------
// AI Exceptions
// -----------------------------------------------------------------------------
abstract class AIException extends PlatformException {
  const AIException(super.message, {super.errorCode, super.cause, super.stackTrace});
}

class ModelNotFoundException extends AIException {
  const ModelNotFoundException(String modelPath)
      : super('Local AI model file not found at path: $modelPath', errorCode: 'AI_MODEL_NOT_FOUND');
}

class ContextWindowExceededException extends AIException {
  const ContextWindowExceededException(int currentTokens, int maxTokens)
      : super('Prompt token count ($currentTokens) exceeds maximum context window ($maxTokens)', errorCode: 'AI_CONTEXT_EXCEEDED');
}

class InferenceFailedException extends AIException {
  const InferenceFailedException(String details, {super.cause, super.stackTrace})
      : super('Native AI inference execution failed: $details', errorCode: 'AI_INFERENCE_FAILED');
}

// -----------------------------------------------------------------------------
// Storage Exceptions
// -----------------------------------------------------------------------------
abstract class StorageException extends PlatformException {
  const StorageException(super.message, {super.errorCode, super.cause, super.stackTrace});
}

class DatabaseCorruptException extends StorageException {
  const DatabaseCorruptException(String dbPath)
      : super('SQLite database file corrupted at path: $dbPath', errorCode: 'STORAGE_DB_CORRUPT');
}

class EventAppendFailedException extends StorageException {
  const EventAppendFailedException(String eventId, String details)
      : super('Failed to append domain event [$eventId] to Event Store: $details', errorCode: 'STORAGE_EVENT_APPEND_FAILED');
}

// -----------------------------------------------------------------------------
// Sync Exceptions
// -----------------------------------------------------------------------------
abstract class SyncException extends PlatformException {
  const SyncException(super.message, {super.errorCode, super.cause, super.stackTrace});
}

class ConflictResolutionFailedException extends SyncException {
  const ConflictResolutionFailedException(String eventId)
      : super('CRDT conflict resolution failed for event: $eventId', errorCode: 'SYNC_CONFLICT_FAILED');
}

class TransportFailedException extends SyncException {
  const TransportFailedException(String endpoint, String details)
      : super('gRPC transport failure connecting to $endpoint: $details', errorCode: 'SYNC_TRANSPORT_FAILED');
}

// -----------------------------------------------------------------------------
// Runtime Exceptions
// -----------------------------------------------------------------------------
abstract class RuntimeException extends PlatformException {
  const RuntimeException(super.message, {super.errorCode, super.cause, super.stackTrace});
}

class FfiLibraryLoadException extends RuntimeException {
  const FfiLibraryLoadException(String libraryName, String details)
      : super('Failed to dynamically load C/FFI shared library [$libraryName]: $details', errorCode: 'RUNTIME_FFI_LOAD_FAILED');
}

// -----------------------------------------------------------------------------
// Audio Exceptions
// -----------------------------------------------------------------------------
abstract class AudioException extends PlatformException {
  const AudioException(super.message, {super.errorCode, super.cause, super.stackTrace});
}

class MicrophonePermissionDeniedException extends AudioException {
  const MicrophonePermissionDeniedException()
      : super('Microphone hardware permission was denied by OS', errorCode: 'AUDIO_MIC_DENIED');
}

// -----------------------------------------------------------------------------
// Configuration Exceptions
// -----------------------------------------------------------------------------
class ConfigurationException extends PlatformException {
  const ConfigurationException(String key)
      : super('Required configuration key missing or invalid: $key', errorCode: 'CONFIG_KEY_INVALID');
}

// -----------------------------------------------------------------------------
// Plugin Exceptions
// -----------------------------------------------------------------------------
abstract class PluginException extends PlatformException {
  const PluginException(super.message, {super.errorCode, super.cause, super.stackTrace});
}

class PluginDependencyMissingException extends PluginException {
  const PluginDependencyMissingException(String pluginId, String missingDepId)
      : super('Plugin [$pluginId] requires missing dependency [$missingDepId]', errorCode: 'PLUGIN_DEP_MISSING');
}

class ManifestInvalidException extends PluginException {
  const ManifestInvalidException(String details)
      : super('Invalid plugin manifest specification: $details', errorCode: 'PLUGIN_MANIFEST_INVALID');
}
