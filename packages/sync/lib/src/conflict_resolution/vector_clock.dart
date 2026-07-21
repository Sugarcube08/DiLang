import 'package:equatable/equatable.dart';

class VectorClock extends Equatable {
  final Map<String, int> clocks;

  const VectorClock(this.clocks);

  factory VectorClock.empty() => const VectorClock({});

  VectorClock increment(String deviceId) {
    final current = clocks[deviceId] ?? 0;
    final updated = Map<String, int>.from(clocks);
    updated[deviceId] = current + 1;
    return VectorClock(updated);
  }

  bool dominates(VectorClock other) {
    var strictlyGreater = false;
    final allDevices = {...clocks.keys, ...other.clocks.keys};

    for (final dev in allDevices) {
      final v1 = clocks[dev] ?? 0;
      final v2 = other.clocks[dev] ?? 0;
      if (v1 < v2) return false;
      if (v1 > v2) strictlyGreater = true;
    }

    return strictlyGreater;
  }

  @override
  List<Object?> get props => [clocks];
}
