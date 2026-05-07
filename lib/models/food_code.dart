import 'package:flutter/foundation.dart';

/// Represents a set of dietary rules and preferences.
@immutable
class FoodCode {
  /// Unique identifier for the food code.
  final String id;

  /// The name of the food code (e.g., "Keto", "Low Sugar").
  final String name;

  /// Optional description of the food code.
  final String? description;

  /// Whether this food code is provided as a starter template.
  final bool isStarter;

  /// List of specific ingredients to ban.
  final List<String> bannedIngredients;

  /// List of emulsifiers to ban.
  final List<String> bannedEmulsifiers;

  /// List of allergens to ban.
  final List<String> allergenBans;

  /// Maximum allowed sugar per serving in grams.
  final double? maxSugarPerServing;

  /// Maximum allowed salt per serving in grams.
  final double? maxSaltPerServing;

  /// Whether to prefer organic products.
  final bool preferOrganic;

  /// Whether to avoid palm oil.
  final bool avoidPalmOil;

  /// Whether to require whole grain.
  final bool requireWholeGrain;

  /// The time when this food code was created.
  final DateTime createdAt;

  /// The time when this food code was last updated.
  final DateTime updatedAt;

  /// Whether this food code is currently active.
  final bool isActive;

  /// Creates a new [FoodCode] instance.
  const FoodCode({
    required this.id,
    required this.name,
    this.description,
    this.isStarter = false,
    this.bannedIngredients = const [],
    this.bannedEmulsifiers = const [],
    this.allergenBans = const [],
    this.maxSugarPerServing,
    this.maxSaltPerServing,
    this.preferOrganic = false,
    this.avoidPalmOil = false,
    this.requireWholeGrain = false,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Creates a copy of this [FoodCode] but with the given fields replaced with the new values.
  FoodCode copyWith({
    String? id,
    String? name,
    String? description,
    bool? isStarter,
    List<String>? bannedIngredients,
    List<String>? bannedEmulsifiers,
    List<String>? allergenBans,
    double? maxSugarPerServing,
    double? maxSaltPerServing,
    bool? preferOrganic,
    bool? avoidPalmOil,
    bool? requireWholeGrain,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return FoodCode(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isStarter: isStarter ?? this.isStarter,
      bannedIngredients: bannedIngredients ?? this.bannedIngredients,
      bannedEmulsifiers: bannedEmulsifiers ?? this.bannedEmulsifiers,
      allergenBans: allergenBans ?? this.allergenBans,
      maxSugarPerServing: maxSugarPerServing ?? this.maxSugarPerServing,
      maxSaltPerServing: maxSaltPerServing ?? this.maxSaltPerServing,
      preferOrganic: preferOrganic ?? this.preferOrganic,
      avoidPalmOil: avoidPalmOil ?? this.avoidPalmOil,
      requireWholeGrain: requireWholeGrain ?? this.requireWholeGrain,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Creates a [FoodCode] instance from a JSON map.
  factory FoodCode.fromJson(Map<String, dynamic> json) {
    return FoodCode(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isStarter: json['isStarter'] as bool? ?? false,
      bannedIngredients: (json['bannedIngredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bannedEmulsifiers: (json['bannedEmulsifiers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergenBans: (json['allergenBans'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxSugarPerServing: (json['maxSugarPerServing'] as num?)?.toDouble(),
      maxSaltPerServing: (json['maxSaltPerServing'] as num?)?.toDouble(),
      preferOrganic: json['preferOrganic'] as bool? ?? false,
      avoidPalmOil: json['avoidPalmOil'] as bool? ?? false,
      requireWholeGrain: json['requireWholeGrain'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Converts this [FoodCode] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isStarter': isStarter,
      'bannedIngredients': bannedIngredients,
      'bannedEmulsifiers': bannedEmulsifiers,
      'allergenBans': allergenBans,
      'maxSugarPerServing': maxSugarPerServing,
      'maxSaltPerServing': maxSaltPerServing,
      'preferOrganic': preferOrganic,
      'avoidPalmOil': avoidPalmOil,
      'requireWholeGrain': requireWholeGrain,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
