import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:caloriecode/models/food_code.dart';

/// Service for managing Food Codes and their persistence.
class FoodCodeService {
  static const String _storageKey = 'food_codes_json';
  static const String _activeCodeKey = 'active_food_code_id';
  static const Uuid _uuid = Uuid();

  FoodCodeService._(); // Private constructor

  /// Gets a specific FoodCode by ID.
  static Future<FoodCode?> getFoodCode(String id) async {
    final codes = await getAllFoodCodes();
    try {
      return codes.firstWhere((code) => code.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Saves a FoodCode (creates or updates).
  static Future<void> saveFoodCode(FoodCode code) async {
    final codes = await getAllFoodCodes();
    final index = codes.indexWhere((c) => c.id == code.id);

    final updatedCode = code.copyWith(updatedAt: DateTime.now());

    if (index >= 0) {
      codes[index] = updatedCode;
    } else {
      codes.add(updatedCode);
    }

    await _saveToPrefs(codes);
  }

  /// Retrieves all FoodCodes from SharedPreferences.
  static Future<List<FoodCode>> getAllFoodCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => FoodCode.fromJson(json)).toList();
      } catch (e) {
        // If there's an error parsing, return empty list or handle accordingly.
        return [];
      }
    }
    return [];
  }

  /// Deletes a FoodCode by ID.
  static Future<void> deleteFoodCode(String id) async {
    final codes = await getAllFoodCodes();
    codes.removeWhere((code) => code.id == id);
    await _saveToPrefs(codes);

    // If the active code was deleted, clear the active code preference
    final prefs = await SharedPreferences.getInstance();
    final activeId = prefs.getString(_activeCodeKey);
    if (activeId == id) {
      await prefs.remove(_activeCodeKey);
    }
  }

  /// Creates a custom clone of a FoodCode with a new ID.
  static FoodCode createCustomCode(FoodCode from) {
    final now = DateTime.now();
    return from.copyWith(
      id: _uuid.v4(),
      isStarter: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Returns the currently active FoodCode.
  static Future<FoodCode?> getActiveCode() async {
    final prefs = await SharedPreferences.getInstance();
    final activeId = prefs.getString(_activeCodeKey);

    if (activeId != null) {
      return await getFoodCode(activeId);
    }
    return null;
  }

  /// Sets the currently active FoodCode by ID.
  static Future<void> setActiveCode(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeCodeKey, id);
  }

  static Future<void> _saveToPrefs(List<FoodCode> codes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(codes.map((c) => c.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  /// Returns a list of 8 predefined starter Food Codes.
  static List<FoodCode> getStarterCodes() {
    final now = DateTime.now();
    return [
      FoodCode(
        id: _uuid.v4(),
        name: 'Mediterranean',
        isStarter: true,
        maxSugarPerServing: 15.0,
        maxSaltPerServing: 0.600, // 600mg
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
        maxSaltPerServing: 0.400, // 400mg
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
        isStarter: true,
        bannedIngredients: const ['pork', 'alcohol', 'shellfish'],
        description: 'Follows Islamic dietary guidelines',
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Whole30',
        isStarter: true,
        maxSugarPerServing: 0.0,
        bannedIngredients: const [
          'dairy',
          'grains',
          'legumes',
          'sugar',
          'additives'
        ],
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
        isStarter: true,
        bannedIngredients: const [
          'raw eggs',
          'unpasteurized dairy',
          'raw meat',
          'high mercury fish'
        ],
        description: 'Safe for pregnancy',
        createdAt: now,
        updatedAt: now,
      ),
      FoodCode(
        id: _uuid.v4(),
        name: 'Low-Sodium',
        isStarter: true,
        maxSaltPerServing: 0.200, // 200mg
        bannedIngredients: const ['processed meat', 'cured foods'],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
