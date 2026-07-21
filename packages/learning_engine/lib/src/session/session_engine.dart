import 'dart:async';
import 'package:equatable/equatable.dart';

enum SessionLifecycleState {
  idle,
  started,
  paused,
  resumed,
  completed,
  evaluated,
  persisted,
}

class SessionResultMetrics extends Equatable {
  final int totalItemsAttempted;
  final int totalSuccesses;
  final int durationSeconds;
  final double accuracyRatio;
  final double retentionGain;

  const SessionResultMetrics({
    required this.totalItemsAttempted,
    required this.totalSuccesses,
    required this.durationSeconds,
    required this.accuracyRatio,
    required this.retentionGain,
  });

  @override
  List<Object?> get props => [
        totalItemsAttempted,
        totalSuccesses,
        durationSeconds,
        accuracyRatio,
        retentionGain,
      ];
}

class LearningSession {
  final String sessionId;
  final String sessionType; // "conversation", "review", "grammar", "listening"
  final String targetLanguage;
  final DateTime startedAt;

  SessionLifecycleState _state = SessionLifecycleState.idle;
  DateTime? _completedAt;
  SessionResultMetrics? _metrics;

  LearningSession({
    required this.sessionId,
    required this.sessionType,
    required this.targetLanguage,
    DateTime? startedAt,
  }) : startedAt = startedAt ?? DateTime.now();

  SessionLifecycleState get state => _state;
  DateTime? get completedAt => _completedAt;
  SessionResultMetrics? get metrics => _metrics;

  void start() {
    if (_state != SessionLifecycleState.idle) {
      throw StateError('Cannot start session in state $_state');
    }
    _state = SessionLifecycleState.started;
  }

  void pause() {
    if (_state != SessionLifecycleState.started && _state != SessionLifecycleState.resumed) {
      throw StateError('Cannot pause session in state $_state');
    }
    _state = SessionLifecycleState.paused;
  }

  void resume() {
    if (_state != SessionLifecycleState.paused) {
      throw StateError('Cannot resume session in state $_state');
    }
    _state = SessionLifecycleState.resumed;
  }

  void complete(SessionResultMetrics metrics) {
    if (_state != SessionLifecycleState.started && _state != SessionLifecycleState.resumed) {
      throw StateError('Cannot complete session in state $_state');
    }
    _metrics = metrics;
    _completedAt = DateTime.now();
    _state = SessionLifecycleState.completed;
  }

  void evaluate() {
    if (_state != SessionLifecycleState.completed) {
      throw StateError('Cannot evaluate session in state $_state');
    }
    _state = SessionLifecycleState.evaluated;
  }

  void persist() {
    if (_state != SessionLifecycleState.evaluated) {
      throw StateError('Cannot persist session in state $_state');
    }
    _state = SessionLifecycleState.persisted;
  }
}
