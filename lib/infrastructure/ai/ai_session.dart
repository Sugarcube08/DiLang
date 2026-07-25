import 'package:equatable/equatable.dart';

enum AiSessionStatus {
  idle,
  runningInference,
  streaming,
  completed,
  failed,
}

class AiSessionMessage extends Equatable {
  final String role;
  final String content;
  final int timestamp;

  const AiSessionMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [role, content, timestamp];
}

class AiSession extends Equatable {
  final String sessionId;
  final String providerName;
  final String modelId;
  final int startedAt;
  final List<AiSessionMessage> messages;
  final AiSessionStatus status;
  final int totalTokensUsed;
  final int latencyMs;

  const AiSession({
    required this.sessionId,
    required this.providerName,
    required this.modelId,
    required this.startedAt,
    this.messages = const [],
    this.status = AiSessionStatus.idle,
    this.totalTokensUsed = 0,
    this.latencyMs = 0,
  });

  AiSession copyWith({
    List<AiSessionMessage>? messages,
    AiSessionStatus? status,
    int? totalTokensUsed,
    int? latencyMs,
  }) {
    return AiSession(
      sessionId: sessionId,
      providerName: providerName,
      modelId: modelId,
      startedAt: startedAt,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      totalTokensUsed: totalTokensUsed ?? this.totalTokensUsed,
      latencyMs: latencyMs ?? this.latencyMs,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        providerName,
        modelId,
        startedAt,
        messages,
        status,
        totalTokensUsed,
        latencyMs,
      ];
}
