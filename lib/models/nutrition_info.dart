import 'package:flutter/foundation.dart';

/// Represents nutritional information for a product.
@immutable
class NutritionInfo {
  /// Calories per 100g of the product.
  final double? caloriesPer100g;

  /// Calories per serving of the product.
  final double? caloriePerServing;

  /// The serving size (e.g., "1 bottle (500ml)").
  final String? servingSize;

  /// Amount of sugar in grams.
  final double? sugar;

  /// Amount of fat in grams.
  final double? fat;

  /// Amount of protein in grams.
  final double? protein;

  /// Amount of carbohydrates in grams.
  final double? carbs;

  /// Amount of fiber in grams.
  final double? fiber;

  /// Amount of salt in grams.
  final double? salt;

  /// Creates a new [NutritionInfo] instance.
  const NutritionInfo({
    this.caloriesPer100g,
    this.caloriePerServing,
    this.servingSize,
    this.sugar,
    this.fat,
    this.protein,
    this.carbs,
    this.fiber,
    this.salt,
  });

  /// Creates a copy of this [NutritionInfo] but with the given fields replaced with the new values.
  NutritionInfo copyWith({
    double? caloriesPer100g,
    double? caloriePerServing,
    String? servingSize,
    double? sugar,
    double? fat,
    double? protein,
    double? carbs,
    double? fiber,
    double? salt,
  }) {
    return NutritionInfo(
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      caloriePerServing: caloriePerServing ?? this.caloriePerServing,
      servingSize: servingSize ?? this.servingSize,
      sugar: sugar ?? this.sugar,
      fat: fat ?? this.fat,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fiber: fiber ?? this.fiber,
      salt: salt ?? this.salt,
    );
  }

  /// Creates a [NutritionInfo] instance from a JSON map.
  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      caloriesPer100g: (json['caloriesPer100g'] as num?)?.toDouble(),
      caloriePerServing: (json['caloriePerServing'] as num?)?.toDouble(),
      servingSize: json['servingSize'] as String?,
      sugar: (json['sugar'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      salt: (json['salt'] as num?)?.toDouble(),
    );
  }

  /// Converts this [NutritionInfo] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'caloriesPer100g': caloriesPer100g,
      'caloriePerServing': caloriePerServing,
      'servingSize': servingSize,
      'sugar': sugar,
      'fat': fat,
      'protein': protein,
      'carbs': carbs,
      'fiber': fiber,
      'salt': salt,
    };
  }
}
