import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilang/shared/theme/dilang_theme.dart';
import 'package:dilang/infrastructure/sqlite/sqlite_storage_engine.dart';
import 'package:dilang/app/dependency_injection/providers.dart';
import 'package:dilang/modules/identity/pages/onboarding_page.dart';

void main() {
  group('Onboarding Page Step Wizard Tests', () {
    testWidgets('OnboardingPage steps forward through setup wizard', (WidgetTester tester) async {
      final inMemoryEngine = SqliteStorageEngine.inMemory();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sqliteEngineProvider.overrideWithValue(inMemoryEngine),
          ],
          child: MaterialApp(
            theme: DiLangTheme.darkTheme,
            home: const OnboardingPage(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('DiLang Setup — Step 1 of 4'), findsOneWidget);
      expect(find.text('What should we call you?'), findsOneWidget);

      // Tap Continue to Step 2
      await tester.tap(find.text('Continue'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('DiLang Setup — Step 2 of 4'), findsOneWidget);
      expect(find.text('Languages & Proficiency'), findsOneWidget);

      inMemoryEngine.dispose();
    });
  });
}
