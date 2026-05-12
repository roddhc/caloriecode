import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/screens/scanner_screen.dart';

void main() {
  testWidgets('ScannerScreen renders guide text and bottom sheet', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ScannerScreen(),
      ),
    );

    // Verify bottom sheet content
    expect(find.text('🧬 Code: Cut Mode'), findsOneWidget);
    expect(find.text('Scan Food'), findsOneWidget);

    // Verify scan button is tappable
    await tester.tap(find.text('Scan Food'));
    await tester.pump();
  });
}
