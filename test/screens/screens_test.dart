import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/screens/home_shell.dart';
import 'package:caloriecode/screens/scanner_screen.dart';
import 'package:caloriecode/screens/history_screen.dart';
import 'package:caloriecode/screens/food_code_screen.dart';
import 'package:caloriecode/screens/settings_screen.dart';
import 'package:caloriecode/screens/result_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      home: child,
      theme: ThemeData(useMaterial3: true),
    );
  }

  group('HomeShell and Navigation', () {
    testWidgets('HomeShell renders all tabs and allows navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const HomeShell()));

      // Initial tab is Scan
      expect(find.byType(ScannerScreen), findsOneWidget);
      expect(find.text('Scan Food'), findsOneWidget);

      // Tap History tab
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();
      expect(find.byType(HistoryScreen), findsOneWidget);
      expect(find.text('History'), findsWidgets);

      // Tap Codes tab
      await tester.tap(find.text('Codes'));
      await tester.pumpAndSettle();
      expect(find.byType(FoodCodeScreen), findsOneWidget);
      expect(find.text('Food Codes'), findsOneWidget);

      // Tap Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });
  });

  group('Individual Screens', () {
    testWidgets('ScannerScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ScannerScreen()));
      expect(find.byType(MobileScanner), findsOneWidget);
      expect(find.text('Active Food Code'), findsOneWidget);
      expect(find.text('Mediterranean'), findsOneWidget);
    });

    testWidgets('ResultScreen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ResultScreen(barcode: '123')));
      await tester.pumpAndSettle(); // Allow animations to finish

      expect(find.textContaining('123'), findsWidgets);
      expect(find.text('Result'), findsWidgets);
      expect(find.text('Scan Again'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      // Tap Scan Again (pops context) - must scroll down since we added SingleChildScrollView
      await tester.scrollUntilVisible(find.text('Scan Again'), 50);
      await tester.tap(find.text('Scan Again'));
      await tester.pumpAndSettle();
      expect(find.byType(ResultScreen), findsNothing);
    });

    testWidgets('HistoryScreen renders correctly and has filter chips', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const HistoryScreen()));
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('🟢 Green'), findsOneWidget);
      expect(find.text('🟡 Yellow'), findsOneWidget);
      expect(find.text('🔴 Red'), findsOneWidget);
    });

    testWidgets('SettingsScreen renders correctly and toggles theme', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const SettingsScreen()));

      expect(find.text('Current Food Code'), findsOneWidget);
      expect(find.text('Edit Food Code'), findsOneWidget);

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // Try tapping the switch
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Test the buttons
      expect(find.text('Upgrade to Premium'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });
  });
}
