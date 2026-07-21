import 'package:equatable/equatable.dart';

class StructuredOutput extends Equatable {
  final String rawText;
  final Map<String, dynamic> jsonPayload;
  final bool isValidJson;

  const StructuredOutput({
    required this.rawText,
    required this.jsonPayload,
    required this.isValidJson,
  });

  @override
  List<Object?> get props => [rawText, jsonPayload, isValidJson];
}
