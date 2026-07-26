import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('DiLang Milestone 0 bootstrap test', (WidgetTester tester) async {
    await tester.pumpWidget(const DiLangApp());
    expect(find.text('DiLang — Milestone 0 Bootstrap'), findsOneWidget);
    expect(find.text('Toolchain Stability Verified'), findsOneWidget);
  });
}
