import 'package:equatable/equatable.dart';

abstract class DomainEvent extends Equatable {
  final String eventId;
  final String aggregateId;
  final DateTime timestamp;
  final String producerModule;
  final int schemaVersion;

  const DomainEvent({
    required this.eventId,
    required this.aggregateId,
    required this.timestamp,
    required this.producerModule,
    this.schemaVersion = 1,
  });

  @override
  List<Object?> get props => [
        eventId,
        aggregateId,
        timestamp,
        producerModule,
        schemaVersion,
      ];
}
