import 'dart:async';
import 'domain_event.dart';

class EventBus {
  final _controller = StreamController<DomainEvent>.broadcast();
  final List<DomainEvent> _history = [];

  Stream<DomainEvent> get stream => _controller.stream;
  List<DomainEvent> get history => List.unmodifiable(_history);

  void publish(DomainEvent event) {
    _history.add(event);
    _controller.add(event);
  }

  Stream<T> on<T extends DomainEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
