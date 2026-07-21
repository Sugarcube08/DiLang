import 'package:equatable/equatable.dart';

class AiDiagnostics extends Equatable {
  final int latencyMs;
  final double tokensPerSecond;
  final int promptTokens;
  final int completionTokens;
  final int ramUsageMb;

  const AiDiagnostics({
    required this.latencyMs,
    required this.tokensPerSecond,
    required this.promptTokens,
    required this.completionTokens,
    required this.ramUsageMb,
  });

  @override
  List<Object?> get props => [
        latencyMs,
        tokensPerSecond,
        promptTokens,
        completionTokens,
        ramUsageMb,
      ];
}
