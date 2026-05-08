import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/screens/history_screen.dart';

void main() {
  testWidgets('HistoryScreen renders filters and items', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HistoryScreen(),
      ),
    );

    // Verify search bar
    expect(find.byType(SearchBar), findsOneWidget);

    // Verify filters
    expect(find.text('All'), findsOneWidget);
    expect(find.text('🟢'), findsWidgets);
    expect(find.text('🟡'), findsWidgets);
    expect(find.text('🔴'), findsWidgets);

    // Verify list items
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Scanned Item 1'), findsOneWidget);

    // Tap filter
    await tester.tap(find.text('🟢').first);
    await tester.pump();
  });
}
