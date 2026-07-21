import 'domain_event.dart';

class GenericRuntimeEvent extends DomainEvent {
  final String eventName;
  final Map<String, dynamic> payload;

  GenericRuntimeEvent({
    required this.eventName,
    required String aggregateId,
    required this.payload,
    String producerModule = 'ui_runtime',
  }) : super(
          eventId: 'evt_${DateTime.now().microsecondsSinceEpoch}',
          aggregateId: aggregateId,
          timestamp: DateTime.now(),
          producerModule: producerModule,
        );

  @override
  List<Object?> get props => [
        ...super.props,
        eventName,
        payload,
      ];
}
