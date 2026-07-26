import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'src/theme/light_theme.dart';
import 'src/theme/dark_theme.dart';
import 'src/components/dilang_splash.dart';
import 'src/components/design_showcase.dart';

void main() {
  // Step 7: Configure Flutter Logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.level.name}] ${record.time}: ${record.message}');
  });

  runApp(
    const ProviderScope(
      child: DiLangApp(),
    ),
  );
}

class DiLangApp extends StatefulWidget {
  const DiLangApp({super.key});

  @override
  State<DiLangApp> createState() => _DiLangAppState();
}

class _DiLangAppState extends State<DiLangApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _showSplash = true;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiLang',
      debugShowCheckedModeBanner: false,
      theme: getLightThemeData(),
      darkTheme: getDarkThemeData(),
      themeMode: _themeMode,
      home: _showSplash
          ? DiLangSplashScreen(
              onSplashComplete: () {
                setState(() => _showSplash = false);
              },
            )
          : DesignSystemShowcaseScreen(
              onToggleTheme: _toggleTheme,
            ),
    );
  }
}
