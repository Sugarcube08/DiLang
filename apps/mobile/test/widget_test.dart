import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('DiLang Design System App test', (WidgetTester tester) async {
    await tester.pumpWidget(const DiLangApp());
    // DiLang splash screen renders initially
    expect(find.text('DiLang'), findsOneWidget);
    expect(find.text('Think in Languages.'), findsOneWidget);
  });
}
