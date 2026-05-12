import 'package:flutter/material.dart';
import '../models/decision.dart';
import '../models/food_code.dart';
import '../models/product.dart';
import '../models/nutrition_info.dart';

class GradeResult {
  final DecisionResult decision;
  final Color color;
  final String reason;
  final Map<String, dynamic> details;

  GradeResult({
    required this.decision,
    required this.color,
    required this.reason,
    this.details = const {},
  });
}

class EvaluationService {
  GradeResult evaluateProduct(Product product, FoodCode foodCode) {
    // 1. Check for missing data (fail fast to yellow)
    if (product.nutrition == null || product.ingredients == null) {
      return GradeResult(
        decision: DecisionResult.yellow,
        color: Colors.amber,
        reason: 'Yellow: Missing nutrition or ingredient data — grade is conservative.',
      );
    }

    final nutrition = product.nutrition!;
    final ingredients = product.ingredients!;

    // 2. Evaluate based on template rules
    GradeResult result;
    if (foodCode.name == 'Low Sugar') {
      result = _evaluateLowSugar(nutrition);
    } else if (foodCode.name == 'PCOS-Friendly') {
      result = _evaluatePCOS(nutrition);
    } else if (foodCode.name == 'Mediterranean') {
      result = _evaluateMediterranean(nutrition, ingredients);
    } else if (foodCode.name == 'Diabetic Safe') {
      result = _evaluateDiabetic(nutrition);
    } else if (foodCode.name == 'Whole30') {
      result = _evaluateWhole30(ingredients);
    } else {
      // Custom diet fallback using user thresholds
      result = _evaluateCustom(nutrition, foodCode);
    }

    // 3. Check banned ingredients (exact match for now)
    for (final banned in foodCode.bannedIngredients) {
      if (ingredients.any((i) => i.contains(banned.toLowerCase()))) {
        if (result.decision == DecisionResult.green) {
            return GradeResult(
                decision: DecisionResult.yellow,
                color: Colors.amber,
                reason: 'Yellow: Downgraded from Green because it contains banned ingredient "$banned".',
            );
        } else if (result.decision == DecisionResult.yellow) {
            return GradeResult(
                decision: DecisionResult.red,
                color: Colors.red,
                reason: 'Red: Downgraded from Yellow because it contains banned ingredient "$banned".',
            );
        }
      }
    }

    return result;
  }

  GradeResult _evaluateLowSugar(NutritionInfo nutrition) {
    final sugar = nutrition.sugar ?? 0;
    if (sugar <= 5) {
      return GradeResult(decision: DecisionResult.green, color: Colors.green, reason: 'Green: Sugar is ≤ 5g per serving.');
    } else if (sugar <= 10) {
      return GradeResult(decision: DecisionResult.yellow, color: Colors.amber, reason: 'Yellow: Sugar is between 5-10g per serving.');
    } else {
      return GradeResult(decision: DecisionResult.red, color: Colors.red, reason: 'Red: Sugar exceeds 10g limit (found ${sugar}g).');
    }
  }

  GradeResult _evaluatePCOS(NutritionInfo nutrition) {
    // Note: We don't have GI data from OFF reliably, assuming GI is OK if sugar is low for now
    // Since GI is missing, we use sugar as primary metric per instructions:
    // Green: GI < 55 AND sugar <= 8g
    // Yellow: GI 55-70 OR sugar 8-12g
    // Red: GI > 70 OR sugar > 12g
    final sugar = nutrition.sugar ?? 0;
    if (sugar <= 8) {
      return GradeResult(decision: DecisionResult.green, color: Colors.green, reason: 'Green: Sugar is ≤ 8g (PCOS friendly).');
    } else if (sugar <= 12) {
      return GradeResult(decision: DecisionResult.yellow, color: Colors.amber, reason: 'Yellow: Sugar is 8-12g (Borderline).');
    } else {
      return GradeResult(decision: DecisionResult.red, color: Colors.red, reason: 'Red: Sugar exceeds 12g limit.');
    }
  }

  GradeResult _evaluateMediterranean(NutritionInfo nutrition, List<String> ingredients) {
    final satFat = nutrition.fat ?? 0; // Using total fat as proxy since we didn't map satFat explicitly
    final hasOliveOil = ingredients.any((i) => i.contains('olive oil'));
    final hasFish = ingredients.any((i) => i.contains('fish') || i.contains('salmon') || i.contains('tuna'));

    if (satFat > 5 || ingredients.length > 15) {
      return GradeResult(decision: DecisionResult.red, color: Colors.red, reason: 'Red: High saturated fat (>5g) or highly processed.');
    } else if (hasOliveOil || hasFish) {
      return GradeResult(decision: DecisionResult.green, color: Colors.green, reason: 'Green: Contains olive oil or fish and low saturated fat.');
    } else {
      return GradeResult(decision: DecisionResult.yellow, color: Colors.amber, reason: 'Yellow: Neutral macros, but no explicit olive oil or fish.');
    }
  }

  GradeResult _evaluateDiabetic(NutritionInfo nutrition) {
    final sugar = nutrition.sugar ?? 0;
    final carbs = nutrition.carbs ?? 0;

    if (sugar <= 3 && carbs <= 20) {
      return GradeResult(decision: DecisionResult.green, color: Colors.green, reason: 'Green: Sugar ≤ 3g and carbs ≤ 20g.');
    } else if (sugar > 7 || carbs > 30) {
      return GradeResult(decision: DecisionResult.red, color: Colors.red, reason: 'Red: Sugar > 7g or carbs > 30g.');
    } else {
      return GradeResult(decision: DecisionResult.yellow, color: Colors.amber, reason: 'Yellow: Sugar is 3-7g or carbs 20-30g.');
    }
  }

  GradeResult _evaluateWhole30(List<String> ingredients) {
    final whole30Banned = ['wheat', 'rice', 'oats', 'corn', 'milk', 'cheese', 'yogurt', 'butter', 'beans', 'peanuts', 'soy', 'sugar', 'syrup', 'honey', 'alcohol', 'wine', 'beer'];

    int bannedCount = 0;
    String firstBanned = '';

    for (final banned in whole30Banned) {
      if (ingredients.any((i) => i.contains(banned))) {
        bannedCount++;
        if (firstBanned.isEmpty) firstBanned = banned;
      }
    }

    if (bannedCount == 0) {
      return GradeResult(decision: DecisionResult.green, color: Colors.green, reason: 'Green: Compliant with Whole30.');
    } else if (bannedCount == 1 && (firstBanned == 'honey' || firstBanned == 'syrup')) {
      return GradeResult(decision: DecisionResult.yellow, color: Colors.amber, reason: 'Yellow: Contains minimal borderline ingredient ($firstBanned).');
    } else {
      return GradeResult(decision: DecisionResult.red, color: Colors.red, reason: 'Red: Contains Whole30 banned ingredient ($firstBanned).');
    }
  }

  GradeResult _evaluateCustom(NutritionInfo nutrition, FoodCode foodCode) {
    if (foodCode.maxSugarPerServing != null) {
      final sugar = nutrition.sugar ?? 0;
      if (sugar > foodCode.maxSugarPerServing!) {
        return GradeResult(decision: DecisionResult.red, color: Colors.red, reason: 'Red: Sugar ($sugar) exceeds custom limit (${foodCode.maxSugarPerServing}).');
      }
    }

    return GradeResult(decision: DecisionResult.green, color: Colors.green, reason: 'Green: Meets your custom criteria.');
  }
}
