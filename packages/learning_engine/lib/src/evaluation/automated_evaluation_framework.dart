import 'package:equatable/equatable.dart';
import '../orchestrator/mission_generator.dart';

class EvaluationTestResult extends Equatable {
  final String testId;
  final String testName;
  final bool passed;
  final String expectedOutput;
  final String actualOutput;
  final double confidenceScore;

  const EvaluationTestResult({
    required this.testId,
    required this.testName,
    required this.passed,
    required this.expectedOutput,
    required this.actualOutput,
    required this.confidenceScore,
  });

  @override
  List<Object?> get props => [
        testId,
        testName,
        passed,
        expectedOutput,
        actualOutput,
        confidenceScore,
      ];
}

class AutomatedEvaluationFramework {
  final MissionGenerator missionGenerator;

  const AutomatedEvaluationFramework({
    this.missionGenerator = const MissionGenerator(),
  });

  List<EvaluationTestResult> runEducationalRegressionSuite() {
    final results = <EvaluationTestResult>[];

    // Test 1: Standard 15m time slot must generate Conversation practice mission
    final m15 = missionGenerator.generateMission(
      targetLanguage: 'DE',
      cefrLevel: 'A1',
      dueReviewsCount: 14,
      timeSlot: AvailableTimeSlot.standard15Min,
    );

    results.add(
      EvaluationTestResult(
        testId: 'eval_01',
        testName: 'Standard Time Slot Mission Assignment',
        passed: m15.primaryActivityType == 'conversation',
        expectedOutput: 'conversation',
        actualOutput: m15.primaryActivityType,
        confidenceScore: 1.0,
      ),
    );

    // Test 2: Quick 5m time slot must generate Review sweep
    final m5 = missionGenerator.generateMission(
      targetLanguage: 'DE',
      cefrLevel: 'A1',
      dueReviewsCount: 8,
      timeSlot: AvailableTimeSlot.quick5Min,
    );

    results.add(
      EvaluationTestResult(
        testId: 'eval_02',
        testName: 'Quick 5m Time Slot Review Sweep',
        passed: m5.primaryActivityType == 'review',
        expectedOutput: 'review',
        actualOutput: m5.primaryActivityType,
        confidenceScore: 1.0,
      ),
    );

    // Test 3: Coaching Briefing must identify root cause
    results.add(
      EvaluationTestResult(
        testId: 'eval_03',
        testName: 'Coaching Root Cause Identification',
        passed: m15.coaching.weakConcept.contains('Accusative'),
        expectedOutput: 'Accusative masculine article inflection (der -> den)',
        actualOutput: m15.coaching.weakConcept,
        confidenceScore: 0.98,
      ),
    );

    return results;
  }
}
