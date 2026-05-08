import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/models/nutrition_info.dart';
import 'package:caloriecode/models/product.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:caloriecode/models/decision.dart';
import 'package:caloriecode/models/scan_history_entry.dart';
import '../utils/test_data.dart';

void main() {
  group('NutritionInfo', () {
    test('JSON serialization', () {
      final json = TestData.mockNutrition.toJson();
      final parsed = NutritionInfo.fromJson(json);
      expect(parsed.caloriesPer100g, TestData.mockNutrition.caloriesPer100g);
      expect(parsed.sugar, TestData.mockNutrition.sugar);
    });

    test('copyWith', () {
      final updated = TestData.mockNutrition.copyWith(sugar: 12.0);
      expect(updated.sugar, 12.0);
      expect(updated.caloriesPer100g, TestData.mockNutrition.caloriesPer100g);
    });
  });

  group('Product', () {
    test('JSON serialization', () {
      final json = TestData.mockProductGreen.toJson();
      final parsed = Product.fromJson(json);
      expect(parsed.barcode, TestData.mockProductGreen.barcode);
      expect(parsed.source, ProductSource.offApi);
      expect(parsed.nutrition?.sugar, TestData.mockProductGreen.nutrition?.sugar);
    });

    test('copyWith', () {
      final updated = TestData.mockProductGreen.copyWith(name: 'New Name');
      expect(updated.name, 'New Name');
      expect(updated.barcode, TestData.mockProductGreen.barcode);
    });

    test('enum conversion in fromJson', () {
      final json = TestData.mockProductGreen.toJson();
      json['source'] = 'unknown'; // fallback to manual
      final parsed = Product.fromJson(json);
      expect(parsed.source, ProductSource.manual);
    });
  });

  group('FoodCode', () {
    test('JSON serialization', () {
      final json = TestData.mockFoodCode.toJson();
      final parsed = FoodCode.fromJson(json);
      expect(parsed.id, TestData.mockFoodCode.id);
      expect(parsed.maxSugarPerServing, TestData.mockFoodCode.maxSugarPerServing);
    });

    test('copyWith', () {
      final updated = TestData.mockFoodCode.copyWith(name: 'Updated Name');
      expect(updated.name, 'Updated Name');
      expect(updated.id, TestData.mockFoodCode.id);
    });
  });

  group('Decision', () {
    test('JSON serialization', () {
      final json = TestData.mockDecision.toJson();
      final parsed = Decision.fromJson(json);
      expect(parsed.result, DecisionResult.green);
      expect(parsed.mode, DecisionMode.buy);
    });

    test('enum conversion in fromJson', () {
      final json = TestData.mockDecision.toJson();
      json['result'] = 'unknown'; // fallback to yellow
      json['mode'] = 'unknown'; // fallback to buy
      final parsed = Decision.fromJson(json);
      expect(parsed.result, DecisionResult.yellow);
      expect(parsed.mode, DecisionMode.buy);
    });
  });

  group('ScanHistoryEntry', () {
    test('JSON serialization', () {
      final json = TestData.mockScanHistoryEntry.toJson();
      final parsed = ScanHistoryEntry.fromJson(json);
      expect(parsed.id, TestData.mockScanHistoryEntry.id);
      expect(parsed.decision, DecisionResult.green);
    });

    test('Map serialization (Database)', () {
      final map = TestData.mockScanHistoryEntry.toMap();
      final parsed = ScanHistoryEntry.fromMap(map);
      expect(parsed.id, TestData.mockScanHistoryEntry.id);
      expect(parsed.decision, DecisionResult.green);
      expect(parsed.scannedAt.millisecondsSinceEpoch, TestData.mockScanHistoryEntry.scannedAt.millisecondsSinceEpoch);
    });

    test('enum conversion in fromJson', () {
      final json = TestData.mockScanHistoryEntry.toJson();
      json['decision'] = 'unknown'; // fallback to yellow
      json['mode'] = 'unknown'; // fallback to buy
      final parsed = ScanHistoryEntry.fromJson(json);
      expect(parsed.decision, DecisionResult.yellow);
      expect(parsed.mode, DecisionMode.buy);
    });
  });
}
