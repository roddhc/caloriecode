import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/models/nutrition_info.dart';
import 'package:caloriecode/models/product.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:caloriecode/models/decision.dart';
import 'package:caloriecode/models/scan_history_entry.dart';

void main() {
  test('NutritionInfo instance and JSON serialization', () {
    final info = const NutritionInfo(caloriesPer100g: 100, sugar: 5.5);
    final json = info.toJson();
    final parsed = NutritionInfo.fromJson(json);
    expect(parsed.caloriesPer100g, 100);
    expect(parsed.sugar, 5.5);
  });

  test('Product instance and JSON serialization', () {
    final prod = const Product(barcode: '123', source: ProductSource.offApi);
    final json = prod.toJson();
    final parsed = Product.fromJson(json);
    expect(parsed.barcode, '123');
    expect(parsed.source, ProductSource.offApi);
  });

  test('FoodCode instance and JSON serialization', () {
    final code = FoodCode(id: '1', name: 'Vegan', createdAt: DateTime.now(), updatedAt: DateTime.now());
    final json = code.toJson();
    final parsed = FoodCode.fromJson(json);
    expect(parsed.id, '1');
    expect(parsed.name, 'Vegan');
  });

  test('Decision instance and JSON serialization', () {
    final dec = Decision(
      productBarcode: '123',
      result: DecisionResult.green,
      explanation: 'All good',
      confidence: 1.0,
      foodCodeId: '1',
      createdAt: DateTime.now(),
      mode: DecisionMode.buy,
    );
    final json = dec.toJson();
    final parsed = Decision.fromJson(json);
    expect(parsed.result, DecisionResult.green);
    expect(parsed.explanation, 'All good');
  });

  test('ScanHistoryEntry instance and JSON serialization', () {
    final entry = ScanHistoryEntry(
      id: '1',
      barcode: '123',
      scannedAt: DateTime.now(),
      decision: DecisionResult.green,
      mode: DecisionMode.buy,
      foodCodeId: '1',
    );
    final json = entry.toJson();
    final parsed = ScanHistoryEntry.fromJson(json);
    expect(parsed.barcode, '123');
    expect(parsed.decision, DecisionResult.green);
  });
}
