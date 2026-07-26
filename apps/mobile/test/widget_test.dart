import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('DiLang Production App Boot test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DiLangApp(),
      ),
    );

    // DiLang splash screen renders title initially
    expect(find.text('DiLang'), findsOneWidget);
    expect(find.text('Privacy-First Local AI Runtime'), findsOneWidget);

    // Pump pending timers and async initialization
    await tester.pumpAndSettle();
  });
}
