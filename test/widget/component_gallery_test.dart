import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dilang/modules/design_system/pages/component_gallery_page.dart';

void main() {
  group('Design System Component Gallery Tests', () {
    testWidgets('ComponentGalleryPage renders and toggles theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ComponentGalleryPage(),
        ),
      );

      expect(find.text('DiLang UI Component Gallery'), findsOneWidget);
      expect(find.text('Button Primitives'), findsOneWidget);
      expect(find.text('Primary Button'), findsOneWidget);

      // Toggle Theme via specific tooltip finder
      final toggleThemeFinder = find.byTooltip('Toggle Theme');
      expect(toggleThemeFinder, findsOneWidget);
      await tester.tap(toggleThemeFinder);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Button Primitives'), findsOneWidget);
    });
  });
}
