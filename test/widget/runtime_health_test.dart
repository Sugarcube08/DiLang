import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilang/shared/theme/dilang_theme.dart';
import 'package:dilang/infrastructure/sqlite/sqlite_storage_engine.dart';
import 'package:dilang/app/dependency_injection/providers.dart';
import 'package:dilang/app/bootstrap/runtime_health_screen.dart';

void main() {
  group('Runtime Health Screen Tests', () {
    testWidgets('RuntimeHealthScreen renders diagnostic dashboard', (WidgetTester tester) async {
      final inMemoryEngine = SqliteStorageEngine.inMemory();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sqliteEngineProvider.overrideWithValue(inMemoryEngine),
          ],
          child: MaterialApp(
            theme: DiLangTheme.darkTheme,
            home: const RuntimeHealthScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('DiLang Runtime Health Diagnostic'), findsOneWidget);
      expect(find.text('Bootstrap Pipeline'), findsOneWidget);
      expect(find.text('SQLite Database Engine'), findsOneWidget);
      expect(find.text('AI Infrastructure Provider'), findsOneWidget);
      expect(find.text('Speech Infrastructure Provider'), findsOneWidget);

      inMemoryEngine.dispose();
    });
  });
}
