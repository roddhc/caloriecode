import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/screens/result_screen.dart';
import 'package:caloriecode/models/product.dart';

import 'package:caloriecode/providers/food_code_provider.dart';
import 'package:caloriecode/providers/scan_history_provider.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../utils/test_data.mocks.dart';

void main() {
  testWidgets('ResultScreen renders correctly', (WidgetTester tester) async {
    final mockFoodCodeProvider = MockFoodCodeProvider();
    final mockScanHistoryProvider = MockScanHistoryProvider();

    when(mockFoodCodeProvider.activeFoodCode).thenReturn(
      FoodCode(
        id: 'test_code',
        name: 'Low Sugar',
        bannedIngredients: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<FoodCodeProvider>.value(value: mockFoodCodeProvider),
          ChangeNotifierProvider<ScanHistoryProvider>.value(value: mockScanHistoryProvider),
        ],
        child: MaterialApp(
          home: ResultScreen(
            barcode: '123456789',
            product: const Product(
              barcode: '123456789',
              name: 'Test Product',
              source: ProductSource.offApi,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify content
    expect(find.text('CAUTION'), findsOneWidget); // Missing data defaults to Yellow
    expect(find.text('Test Product'), findsOneWidget);

    // Verify Add to History button
    expect(find.text('Add to History'), findsOneWidget);

    // Test tapping Scan Another (it should pop the screen)
    await tester.tap(find.text('Scan Another').first);
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsNothing);
  });
}
