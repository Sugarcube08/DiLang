import 'package:flutter/material.dart';

/// Centralized Icon Abstraction.
/// UI screens must NEVER reference raw Material/Cupertino icons directly.
/// This allows switching icon libraries (Phosphor, Lucide, SVG) without touching screens.
abstract class DiIcons {
  static const IconData settings = Icons.settings_rounded;
  static const IconData mic = Icons.mic_rounded;
  static const IconData brain = Icons.psychology_rounded;
  static const IconData analytics = Icons.insights_rounded;
  static const IconData learning = Icons.auto_stories_rounded;
  static const IconData play = Icons.play_arrow_rounded;
  static const IconData tune = Icons.tune_rounded;
  static const IconData themeToggle = Icons.brightness_6_rounded;
  static const IconData lightMode = Icons.light_mode_rounded;
  static const IconData darkMode = Icons.dark_mode_rounded;
  static const IconData spark = Icons.auto_awesome_rounded;
  static const IconData check = Icons.check_circle_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData time = Icons.access_time_rounded;
  static const IconData speaker = Icons.volume_up_rounded;
}
