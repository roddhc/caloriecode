import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen renders options', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    // Verify sections
    expect(find.text('Current Food Code'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);

    // Verify switch toggles (we have two switches now: Dark Mode, Notifications)
    await tester.tap(find.byType(Switch).first);
    await tester.pump();
  });
}
