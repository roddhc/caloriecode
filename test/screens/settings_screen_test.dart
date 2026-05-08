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
    expect(find.text('Vegan'), findsOneWidget);
    expect(find.text('Upgrade to Premium'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('About CalorieCode'), findsOneWidget);

    // Verify Edit button is tappable
    await tester.tap(find.text('Edit'));
    await tester.pump();

    // Verify switch toggles
    await tester.tap(find.byType(Switch));
    await tester.pump();
  });
}
