import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/models/decision.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:caloriecode/models/product.dart';
import 'package:caloriecode/models/nutrition_info.dart';
import 'package:caloriecode/services/evaluation_service.dart';

void main() {
  late EvaluationService service;

  setUp(() {
    service = EvaluationService();
  });

  group('EvaluationService', () {
    test('missing data returns yellow', () {
      final code = FoodCode(
        id: '1',
        name: 'Low Sugar',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final product = Product(
        barcode: '123',
        source: ProductSource.offApi,
        // nutrition and ingredients are null
      );

      final result = service.evaluateProduct(product, code);
      expect(result.decision, DecisionResult.yellow);
      expect(result.color, Colors.amber);
      expect(result.reason, contains('Missing'));
    });

    test('banned ingredients downgrade tier', () {
      final code = FoodCode(
        id: '1',
        name: 'Low Sugar',
        bannedIngredients: ['hfcs'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      // Base evaluation is Green (sugar 0), so ban should downgrade to Yellow
      final product1 = Product(
        barcode: '123',
        source: ProductSource.offApi,
        nutrition: const NutritionInfo(sugar: 0),
        ingredients: ['water', 'hfcs'],
      );

      final result1 = service.evaluateProduct(product1, code);
      expect(result1.decision, DecisionResult.yellow);
      expect(result1.reason, contains('Downgraded from Green'));

      // Base evaluation is Yellow (sugar 8), so ban should downgrade to Red
      final product2 = Product(
        barcode: '456',
        source: ProductSource.offApi,
        nutrition: const NutritionInfo(sugar: 8),
        ingredients: ['water', 'hfcs'],
      );

      final result2 = service.evaluateProduct(product2, code);
      expect(result2.decision, DecisionResult.red);
      expect(result2.reason, contains('Downgraded from Yellow'));
    });

    group('Low Sugar Diet', () {
      final code = FoodCode(
        id: '1',
        name: 'Low Sugar',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('Green when sugar <= 5', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 4),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.green);
      });

      test('Yellow when sugar 5-10', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 8),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.yellow);
      });

      test('Red when sugar > 10', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 14),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.red);
      });
    });

    group('PCOS-Friendly Diet', () {
      final code = FoodCode(
        id: '2',
        name: 'PCOS-Friendly',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('Green when sugar <= 8', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 5),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.green);
      });

      test('Yellow when sugar 8-12', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 10),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.yellow);
      });

      test('Red when sugar > 12', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 15),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.red);
      });
    });

    group('Mediterranean Diet', () {
      final code = FoodCode(
        id: '3',
        name: 'Mediterranean',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('Red if fat > 5', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(fat: 6),
          ingredients: ['olive oil'],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.red);
      });

      test('Green if fat <= 5 and contains olive oil', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(fat: 4),
          ingredients: ['water', 'olive oil'],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.green);
      });

      test('Yellow if neutral macros but no olive oil/fish', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(fat: 3),
          ingredients: ['water', 'salt'],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.yellow);
      });
    });

    group('Diabetic Safe Diet', () {
      final code = FoodCode(
        id: '4',
        name: 'Diabetic Safe',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('Green if sugar <= 3 and carbs <= 20', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 2, carbs: 15),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.green);
      });

      test('Red if sugar > 7 or carbs > 30', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 8, carbs: 10),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.red);
      });

      test('Yellow if intermediate', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(sugar: 5, carbs: 25),
          ingredients: [],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.yellow);
      });
    });

    group('Whole30 Diet', () {
      final code = FoodCode(
        id: '5',
        name: 'Whole30',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      test('Green if no banned ingredients', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(),
          ingredients: ['chicken', 'water'],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.green);
      });

      test('Red if contains banned ingredient', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(),
          ingredients: ['chicken', 'wheat'],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.red);
      });

      test('Yellow if only one borderline ingredient (honey)', () {
        final product = Product(
          barcode: '123',
          source: ProductSource.offApi,
          nutrition: const NutritionInfo(),
          ingredients: ['chicken', 'honey'],
        );
        final result = service.evaluateProduct(product, code);
        expect(result.decision, DecisionResult.yellow);
      });
    });
  });
}
