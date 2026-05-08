import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/screens/result_screen.dart';

void main() {
  testWidgets('ResultScreen renders correctly', (WidgetTester tester) async {
    const testBarcode = '123456789012';

    await tester.pumpWidget(
      const MaterialApp(
        home: ResultScreen(barcode: testBarcode),
      ),
    );
    await tester.pumpAndSettle();

    // Verify content
    expect(find.text('Avoid'), findsOneWidget);
    expect(find.text('Barcode: $testBarcode'), findsOneWidget);
    expect(find.text('Contains high sugar'), findsOneWidget);
    expect(find.text('Healthy Oat Cookies'), findsOneWidget);

    // Verify Scan Again button
    expect(find.text('Scan Again'), findsOneWidget);

    // Test tapping Scan Again (it should pop the screen)
    await tester.tap(find.text('Scan Again'));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsNothing);
  });
}
