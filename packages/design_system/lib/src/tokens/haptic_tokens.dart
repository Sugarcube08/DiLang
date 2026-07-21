enum HapticPattern { tap, correct, incorrect, achievement, sessionComplete }

class HapticTokens {
  static const int tapDurationMs = 10;
  static const int correctPulseCount = 2;
  static const int errorDurationMs = 40;

  const HapticTokens();
}
