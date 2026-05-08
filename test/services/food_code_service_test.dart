import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:caloriecode/services/food_code_service.dart';

void main() {
  setUp(() {
    // Clear mock SharedPreferences before each test
    SharedPreferences.setMockInitialValues({});
  });

  group('FoodCodeService Starter Templates', () {
    test('getStarterCodes should return exactly 8 templates', () {
      final templates = FoodCodeService.getStarterCodes();
      expect(templates.length, 8);

      final names = templates.map((t) => t.name).toList();
      expect(names, containsAll([
        'Mediterranean',
        'PCOS-Friendly',
        'Diabetic-Safe',
        'Halal',
        'Whole30',
        'Low-FODMAP',
        'Pregnancy-Safe',
        'Low-Sodium'
      ]));

      // Check properties on a specific one, e.g. Low-Sodium
      final lowSodium = templates.firstWhere((t) => t.name == 'Low-Sodium');
      expect(lowSodium.maxSaltPerServing, 0.2); // 200mg
      expect(lowSodium.isStarter, isTrue);
    });
  });

  group('FoodCodeService CRUD operations', () {
    test('saveFoodCode and getFoodCode work correctly', () async {
      final code = FoodCode(
        id: 'test_123',
        name: 'Test Code',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FoodCodeService.saveFoodCode(code);

      final retrieved = await FoodCodeService.getFoodCode('test_123');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Test Code');
      expect(retrieved.id, 'test_123');
    });

    test('getAllFoodCodes returns all saved codes', () async {
      final code1 = FoodCode(id: '1', name: 'Code 1', createdAt: DateTime.now(), updatedAt: DateTime.now());
      final code2 = FoodCode(id: '2', name: 'Code 2', createdAt: DateTime.now(), updatedAt: DateTime.now());

      await FoodCodeService.saveFoodCode(code1);
      await FoodCodeService.saveFoodCode(code2);

      final allCodes = await FoodCodeService.getAllFoodCodes();
      expect(allCodes.length, 2);
    });

    test('deleteFoodCode deletes the code', () async {
      final code = FoodCode(id: '1', name: 'Code 1', createdAt: DateTime.now(), updatedAt: DateTime.now());
      await FoodCodeService.saveFoodCode(code);

      expect((await FoodCodeService.getAllFoodCodes()).length, 1);

      await FoodCodeService.deleteFoodCode('1');
      expect((await FoodCodeService.getAllFoodCodes()).length, 0);
    });

    test('deleteFoodCode removes it from active if it was active', () async {
      final code = FoodCode(id: '1', name: 'Code 1', createdAt: DateTime.now(), updatedAt: DateTime.now());
      await FoodCodeService.saveFoodCode(code);
      await FoodCodeService.setActiveCode('1');

      var active = await FoodCodeService.getActiveCode();
      expect(active?.id, '1');

      await FoodCodeService.deleteFoodCode('1');

      active = await FoodCodeService.getActiveCode();
      expect(active, isNull);
    });
  });

  group('FoodCodeService Utilities', () {
    test('createCustomCode creates a clone with a new ID and isStarter=false', () {
      final original = FoodCode(
        id: 'original',
        name: 'Original',
        isStarter: true,
        bannedIngredients: const ['apple'],
        createdAt: DateTime(2000),
        updatedAt: DateTime(2000),
      );

      final clone = FoodCodeService.createCustomCode(original);

      expect(clone.id, isNot('original'));
      expect(clone.name, 'Original');
      expect(clone.isStarter, isFalse);
      expect(clone.bannedIngredients, ['apple']);
      // Should have new timestamps
      expect(clone.createdAt.year, isNot(2000));
    });

    test('setActiveCode and getActiveCode work correctly', () async {
      final code = FoodCode(id: 'active_1', name: 'Active Code', createdAt: DateTime.now(), updatedAt: DateTime.now());
      await FoodCodeService.saveFoodCode(code);

      await FoodCodeService.setActiveCode('active_1');

      final retrieved = await FoodCodeService.getActiveCode();
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Active Code');
    });
  });
}
