import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:caloriecode/services/food_code_service.dart';

void main() {
  group('FoodCodeService Tests', () {
    late FoodCodeService service;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      service = FoodCodeService(prefs);
    });

    test('getStarterCodes returns exactly 8 templates', () {
      final starterCodes = service.getStarterCodes();

      expect(starterCodes.length, 8);

      final names = starterCodes.map((c) => c.name).toList();
      expect(names, containsAll([
        'Mediterranean',
        'PCOS-Friendly',
        'Diabetic-Safe',
        'Halal',
        'Whole30',
        'Low-FODMAP',
        'Pregnancy-Safe',
        'Low-Sodium',
      ]));

      for (final code in starterCodes) {
        expect(code.isStarter, true);
        expect(code.id, isNotEmpty);
      }
    });

    test('saveFoodCode and getFoodCode work correctly', () async {
      final now = DateTime.now();
      final code = FoodCode(
        id: 'test-123',
        name: 'Test Code',
        createdAt: now,
        updatedAt: now,
      );

      // Verify it doesn't exist yet
      expect(await service.getFoodCode('test-123'), isNull);

      // Save it
      await service.saveFoodCode(code);

      // Retrieve it
      final retrieved = await service.getFoodCode('test-123');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'test-123');
      expect(retrieved.name, 'Test Code');
    });

    test('saveFoodCode updates existing code', () async {
      final now = DateTime.now();
      final code = FoodCode(
        id: 'test-update',
        name: 'Initial Name',
        createdAt: now,
        updatedAt: now,
      );

      await service.saveFoodCode(code);

      final updatedCode = code.copyWith(name: 'Updated Name');
      await service.saveFoodCode(updatedCode);

      final retrieved = await service.getFoodCode('test-update');
      expect(retrieved!.name, 'Updated Name');

      final all = await service.getAllFoodCodes();
      expect(all.length, 1); // Ensure it replaced, didn't duplicate
    });

    test('getAllFoodCodes returns all saved codes', () async {
      final now = DateTime.now();

      await service.saveFoodCode(FoodCode(id: '1', name: 'One', createdAt: now, updatedAt: now));
      await service.saveFoodCode(FoodCode(id: '2', name: 'Two', createdAt: now, updatedAt: now));

      final all = await service.getAllFoodCodes();
      expect(all.length, 2);
      expect(all.map((c) => c.id), containsAll(['1', '2']));
    });

    test('deleteFoodCode removes code', () async {
      final now = DateTime.now();
      await service.saveFoodCode(FoodCode(id: 'delete-me', name: 'Delete', createdAt: now, updatedAt: now));

      expect(await service.getFoodCode('delete-me'), isNotNull);

      await service.deleteFoodCode('delete-me');

      expect(await service.getFoodCode('delete-me'), isNull);
    });

    test('createCustomCode clones correctly with new ID and isStarter false', () {
      final starter = service.getStarterCodes().first;

      final custom = service.createCustomCode(starter);

      expect(custom.id, isNot(equals(starter.id)));
      expect(custom.name, '${starter.name} (Custom)');
      expect(custom.isStarter, false);
      expect(custom.bannedIngredients, equals(starter.bannedIngredients));
      expect(custom.maxSugarPerServing, equals(starter.maxSugarPerServing));
    });

    test('setActiveCode and getActiveCode work correctly', () async {
      final now = DateTime.now();
      final code = FoodCode(id: 'active-test', name: 'Active', createdAt: now, updatedAt: now);
      await service.saveFoodCode(code);

      expect(await service.getActiveCode(), isNull);

      await service.setActiveCode('active-test');

      final active = await service.getActiveCode();
      expect(active, isNotNull);
      expect(active!.id, 'active-test');
    });

    test('getActiveCode returns null if active code is deleted', () async {
      final now = DateTime.now();
      final code = FoodCode(id: 'active-del', name: 'Active Delete', createdAt: now, updatedAt: now);
      await service.saveFoodCode(code);
      await service.setActiveCode('active-del');

      expect(await service.getActiveCode(), isNotNull);

      await service.deleteFoodCode('active-del');

      expect(await service.getActiveCode(), isNull);
    });
  });
}
