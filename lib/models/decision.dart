import 'package:flutter/foundation.dart';

/// The result of evaluating a product against a FoodCode.
enum DecisionResult {
  /// The product is compliant with the FoodCode.
  green,

  /// The product has warnings or borderline compliance.
  yellow,

  /// The product violates the FoodCode.
  red,
}

/// The context or mode in which the decision is being made.
enum DecisionMode {
  /// Evaluating for purchase.
  buy,

  /// Evaluating for consumption.
  eat,
}

/// Represents the outcome of evaluating a product against a food code.
@immutable
class Decision {
  /// The barcode of the evaluated product.
  final String productBarcode;

  /// The overall result of the evaluation.
  final DecisionResult result;

  /// A detailed explanation of the decision.
  final String explanation;

  /// A list of specific reasons for the decision result.
  final List<String> reasons;

  /// A list of barcodes for alternative products, if any.
  final List<String> alternatives;

  /// Confidence level of the decision, from 0.0 to 1.0.
  final double confidence;

  /// The ID of the food code used for this decision.
  final String foodCodeId;

  /// The time when this decision was made.
  final DateTime createdAt;

  /// The mode in which this decision was made.
  final DecisionMode mode;

  /// Creates a new [Decision] instance.
  const Decision({
    required this.productBarcode,
    required this.result,
    required this.explanation,
    this.reasons = const [],
    this.alternatives = const [],
    required this.confidence,
    required this.foodCodeId,
    required this.createdAt,
    required this.mode,
  });

  /// Creates a [Decision] instance from a JSON map.
  factory Decision.fromJson(Map<String, dynamic> json) {
    return Decision(
      productBarcode: json['productBarcode'] as String,
      result: DecisionResult.values.firstWhere(
        (e) => e.name == json['result'],
        orElse: () => DecisionResult.yellow,
      ),
      explanation: json['explanation'] as String,
      reasons: (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      alternatives: (json['alternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      confidence: (json['confidence'] as num).toDouble(),
      foodCodeId: json['foodCodeId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      mode: DecisionMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => DecisionMode.buy,
      ),
    );
  }

  /// Converts this [Decision] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'productBarcode': productBarcode,
      'result': result.name,
      'explanation': explanation,
      'reasons': reasons,
      'alternatives': alternatives,
      'confidence': confidence,
      'foodCodeId': foodCodeId,
      'createdAt': createdAt.toIso8601String(),
      'mode': mode.name,
    };
  }
}
