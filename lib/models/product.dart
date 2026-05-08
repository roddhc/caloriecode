import 'package:flutter/foundation.dart';
import 'nutrition_info.dart';

/// The source from which the product data was obtained.
enum ProductSource {
  /// Open Food Facts API
  offApi,

  /// USDA API
  usdaApi,

  /// Optical Character Recognition (scanned from label)
  ocr,

  /// Manually entered by the user
  manual,
}

/// Represents a scanned or manually entered food product.
@immutable
class Product {
  /// The barcode of the product.
  final String barcode;

  /// The name of the product.
  final String? name;

  /// The brand of the product.
  final String? brand;

  /// Nutritional information for the product.
  final NutritionInfo? nutrition;

  /// List of ingredients in the product.
  final List<String>? ingredients;

  /// List of known allergens in the product.
  final List<String>? allergens;

  /// The source of this product's data.
  final ProductSource source;

  /// The time when this product data was cached.
  final DateTime? cachedAt;

  /// Creates a new [Product] instance.
  const Product({
    required this.barcode,
    this.name,
    this.brand,
    this.nutrition,
    this.ingredients,
    this.allergens,
    required this.source,
    this.cachedAt,
  });

  /// Creates a copy of this [Product] but with the given fields replaced with the new values.
  Product copyWith({
    String? barcode,
    String? name,
    String? brand,
    NutritionInfo? nutrition,
    List<String>? ingredients,
    List<String>? allergens,
    ProductSource? source,
    DateTime? cachedAt,
  }) {
    return Product(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      nutrition: nutrition ?? this.nutrition,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      source: source ?? this.source,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  /// Creates a [Product] instance from a JSON map.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'] as String,
      name: json['name'] as String?,
      brand: json['brand'] as String?,
      nutrition: json['nutrition'] != null
          ? NutritionInfo.fromJson(json['nutrition'] as Map<String, dynamic>)
          : null,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      source: ProductSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => ProductSource.manual,
      ),
      cachedAt: json['cachedAt'] != null
          ? DateTime.tryParse(json['cachedAt'] as String)
          : null,
    );
  }

  /// Converts this [Product] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'nutrition': nutrition?.toJson(),
      'ingredients': ingredients,
      'allergens': allergens,
      'source': source.name,
      'cachedAt': cachedAt?.toIso8601String(),
    };
  }
}
