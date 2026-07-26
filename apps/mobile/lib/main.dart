import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'src/theme/light_theme.dart';
import 'src/theme/dark_theme.dart';
import 'src/app/app_router.dart';

void main() {
  debugPrint("=== DILANG MAIN APP STARTED ===");
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

class DiLangApp extends StatelessWidget {
  const DiLangApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("=== BUILDING DILANG APP WITH MATERIALAPP.ROUTER ===");
    return MaterialApp.router(
      title: 'DiLang',
      debugShowCheckedModeBanner: false,
      theme: getLightThemeData(),
      darkTheme: getDarkThemeData(),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
