import 'dart:async';
import 'domain_event.dart';
import '../logger/logger_contract.dart';

typedef EventHandler<T extends DomainEvent> = FutureOr<void> Function(T event);

class EventSubscription {
  final StreamSubscription<dynamic> _subscription;

  EventSubscription(this._subscription);

  Future<void> cancel() async {
    await _subscription.cancel();
  }
}

class EventBus {
  final StreamController<DomainEvent> _controller = StreamController<DomainEvent>.broadcast();
  final LoggerContract? logger;
  final List<DomainEvent> _history = [];

  EventBus({this.logger});

  List<DomainEvent> get history => List.unmodifiable(_history);

  void publish(DomainEvent event) {
    logger?.debug('EventBus Published [${event.runtimeType}] aggregateId:${event.aggregateId}');
    _history.add(event);
    _controller.add(event);
  }

  EventSubscription subscribe<T extends DomainEvent>(EventHandler<T> handler) {
    // ignore: cancel_subscriptions
    final sub = _controller.stream.where((event) => event is T).cast<T>().listen((event) async {
      try {
        await handler(event);
      } catch (e, stackTrace) {
        logger?.error('Error handling event [${event.runtimeType}]: $e', e, stackTrace);
      }
    });

    return EventSubscription(sub);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
