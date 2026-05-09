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
    expect(find.text('WORTH IT'), findsOneWidget);
    expect(find.text('High protein (20g)'), findsOneWidget);

    // Verify Scan Again button
    expect(find.text('Scan Again'), findsWidgets); // Found multiple scan texts

    // Test tapping Scan Again (it should pop the screen)
    await tester.tap(find.text('Scan Again').first);
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsNothing);
  });
}
