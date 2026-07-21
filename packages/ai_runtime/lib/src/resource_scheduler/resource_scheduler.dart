import 'package:equatable/equatable.dart';

class HardwareProfile extends Equatable {
  final int totalRamMb;
  final int availableRamMb;
  final int cpuPhysicalCores;
  final bool hasGpuAcceleration;
  final String gpuBackendName;

  const HardwareProfile({
    required this.totalRamMb,
    required this.availableRamMb,
    required this.cpuPhysicalCores,
    required this.hasGpuAcceleration,
    required this.gpuBackendName,
  });

  @override
  List<Object?> get props => [
        totalRamMb,
        availableRamMb,
        cpuPhysicalCores,
        hasGpuAcceleration,
        gpuBackendName,
      ];
}

class AllocationPlan extends Equatable {
  final int threadsToUse;
  final int gpuLayersToOffload;
  final int maxContextTokens;
  final bool allowExecution;

  const AllocationPlan({
    required this.threadsToUse,
    required this.gpuLayersToOffload,
    required this.maxContextTokens,
    required this.allowExecution,
  });

  @override
  List<Object?> get props => [
        threadsToUse,
        gpuLayersToOffload,
        maxContextTokens,
        allowExecution,
      ];
}

class ResourceScheduler {
  AllocationPlan scheduleAllocation({
    required HardwareProfile hardware,
    required int requestedRamMb,
    required int requestedContextTokens,
  }) {
    if (hardware.availableRamMb < (requestedRamMb * 0.8)) {
      return const AllocationPlan(
        threadsToUse: 1,
        gpuLayersToOffload: 0,
        maxContextTokens: 1024,
        allowExecution: false,
      );
    }

    final threads = (hardware.cpuPhysicalCores - 1).clamp(1, 16);
    final gpuLayers = hardware.hasGpuAcceleration ? 32 : 0;
    final context = requestedContextTokens.clamp(512, 8192);

    return AllocationPlan(
      threadsToUse: threads,
      gpuLayersToOffload: gpuLayers,
      maxContextTokens: context,
      allowExecution: true,
    );
  }
}
