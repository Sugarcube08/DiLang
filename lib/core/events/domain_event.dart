import 'package:equatable/equatable.dart';

abstract class DomainEvent extends Equatable {
  final String eventId;
  final String aggregateId;
  final DateTime timestamp;
  final String producerModule;

  const DomainEvent({
    required this.eventId,
    required this.aggregateId,
    required this.timestamp,
    required this.producerModule,
  });

  @override
  List<Object?> get props => [eventId, aggregateId, timestamp, producerModule];
}

class GenericRuntimeEvent extends DomainEvent {
  final String eventName;
  final Map<String, dynamic> payload;

  const GenericRuntimeEvent({
    required super.eventId,
    required super.aggregateId,
    required super.timestamp,
    required super.producerModule,
    required this.eventName,
    required this.payload,
  });

  @override
  List<Object?> get props => [...super.props, eventName, payload];
}

class TurnCompletedEvent extends DomainEvent {
  final String sessionId;
  final String userText;
  final String agentText;

  const TurnCompletedEvent({
    required super.eventId,
    required super.aggregateId,
    required super.timestamp,
    required super.producerModule,
    required this.sessionId,
    required this.userText,
    required this.agentText,
  });

  @override
  List<Object?> get props => [...super.props, sessionId, userText, agentText];
}
