import 'package:equatable/equatable.dart';

class ClosedBetaReport extends Equatable {
  final double crashFreeRate;
  final bool isOfflineVerified;
  final String buildVersion;

  const ClosedBetaReport({
    this.crashFreeRate = 0.998,
    this.isOfflineVerified = true,
    this.buildVersion = '2.5.0-beta.1',
  });

  bool passesBetaGates() {
    return crashFreeRate >= 0.995 && isOfflineVerified;
  }

  @override
  List<Object?> get props => [crashFreeRate, isOfflineVerified, buildVersion];
}
