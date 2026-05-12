import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/screens/home_shell.dart';
import 'package:caloriecode/screens/scanner_screen.dart';
import 'package:caloriecode/screens/history_screen.dart';
import 'package:caloriecode/screens/food_code_screen.dart';
import 'package:caloriecode/screens/settings_screen.dart';

void main() {
  testWidgets('HomeShell renders NavigationBar and transitions between tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeShell(),
      ),
    );

    // Initial state should show ScannerScreen
    expect(find.byType(ScannerScreen), findsOneWidget);

    // Tap on History tab
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.byType(HistoryScreen), findsOneWidget);

    // Tap on Code tab
    await tester.tap(find.text('Code'));
    await tester.pumpAndSettle();
    expect(find.byType(FoodCodeScreen), findsOneWidget);

    // Tap on Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });
}
