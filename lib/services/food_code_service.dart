import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/food_code.dart';

/// Service for managing [FoodCode]s.
class FoodCodeService {
  static const String _foodCodesKey = 'food_codes_json';
  static const String _activeCodeKey = 'active_food_code_id';

  final SharedPreferences _prefs;
  final Uuid _uuid = const Uuid();

  /// Creates a new [FoodCodeService] instance.
  FoodCodeService(this._prefs);

  /// Saves a [FoodCode] to storage.
  Future<void> saveFoodCode(FoodCode code) async {
    final codes = await getAllFoodCodes();
    final index = codes.indexWhere((c) => c.id == code.id);

    if (index >= 0) {
      codes[index] = code;
    } else {
      codes.add(code);
    }

    final jsonString = jsonEncode(codes.map((c) => c.toJson()).toList());
    await _prefs.setString(_foodCodesKey, jsonString);
  }

  /// Gets a [FoodCode] by its ID.
  Future<FoodCode?> getFoodCode(String id) async {
    final codes = await getAllFoodCodes();
    try {
      return codes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Gets all saved [FoodCode]s.
  Future<List<FoodCode>> getAllFoodCodes() async {
    final jsonString = _prefs.getString(_foodCodesKey);
    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => FoodCode.fromJson(json as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Deletes a [FoodCode] by its ID.
  Future<void> deleteFoodCode(String id) async {
    final codes = await getAllFoodCodes();
    codes.removeWhere((c) => c.id == id);

    final jsonString = jsonEncode(codes.map((c) => c.toJson()).toList());
    await _prefs.setString(_foodCodesKey, jsonString);

    final activeId = _prefs.getString(_activeCodeKey);
    if (activeId == id) {
      await _prefs.remove(_activeCodeKey);
    }
  }

  /// Creates a custom [FoodCode] cloned from an existing one.
  FoodCode createCustomCode(FoodCode from) {
    final now = DateTime.now();
    return from.copyWith(
      id: _uuid.v4(),
      isStarter: false,
      name: '${from.name} (Custom)',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Gets the currently active [FoodCode].
  Future<FoodCode?> getActiveCode() async {
    final activeId = _prefs.getString(_activeCodeKey);
    if (activeId == null) {
      return null;
    }

    final code = await getFoodCode(activeId);
    if (code == null) {
      // If the active code was deleted, clear the active ID.
      await _prefs.remove(_activeCodeKey);
    }
    return code;
  }

  /// Sets the active [FoodCode] by its ID.
  Future<void> setActiveCode(String id) async {
    await _prefs.setString(_activeCodeKey, id);
  }

  /// Gets the 8 starter [FoodCode] templates.
  List<FoodCode> getStarterCodes() {
    final now = DateTime.now();

    return [
      FoodCode(
        id: _uuid.v4(),
        name: 'Mediterranean',
        isStarter: true,
        maxSugarPerServing: 15.0,
        maxSaltPerServing: 0.6,
        bannedIngredients: const ['seed oils'],
        preferOrganic: true,
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'PCOS-Friendly',
        isStarter: true,
        maxSugarPerServing: 10.0,
        maxSaltPerServing: 0.4,
        bannedIngredients: const ['high fructose corn syrup', 'refined grains'],
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Diabetic-Safe',
        isStarter: true,
        maxSugarPerServing: 5.0,
        bannedIngredients: const ['HFCS', 'artificial sweeteners'],
        requireWholeGrain: true,
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Halal',
        description: 'Follows Islamic dietary guidelines',
        isStarter: true,
        bannedIngredients: const ['pork', 'alcohol', 'shellfish'],
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Whole30',
        isStarter: true,
        maxSugarPerServing: 0.0,
        bannedIngredients: const ['dairy', 'grains', 'legumes', 'sugar', 'additives'],
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Low-FODMAP',
        isStarter: true,
        maxSugarPerServing: 15.0,
        bannedIngredients: const ['garlic', 'onion', 'wheat', 'dairy'],
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Pregnancy-Safe',
        description: 'Safe for pregnancy',
        isStarter: true,
        bannedIngredients: const ['raw eggs', 'unpasteurized dairy', 'raw meat', 'high mercury fish'],
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Low-Sodium',
        isStarter: true,
        maxSaltPerServing: 0.2,
        bannedIngredients: const ['processed meat', 'cured foods'],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
