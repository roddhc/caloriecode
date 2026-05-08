import 'package:flutter/foundation.dart';
import 'decision.dart';

/// Represents an entry in the user's scan history.
@immutable
class ScanHistoryEntry {
  /// Unique identifier for this history entry.
  final String id;

  /// The barcode of the scanned product.
  final String barcode;

  /// The name of the scanned product, if available.
  final String? productName;

  /// The time when the product was scanned.
  final DateTime scannedAt;

  /// The decision result at the time of scanning.
  final DecisionResult decision;

  /// The mode in which the decision was made.
  final DecisionMode mode;

  /// The ID of the food code used for the decision.
  final String foodCodeId;

  /// Optional notes added by the user.
  final String? notes;

  /// Whether this entry was explicitly saved by the user.
  final bool wasSaved;

  /// Creates a new [ScanHistoryEntry] instance.
  const ScanHistoryEntry({
    required this.id,
    required this.barcode,
    this.productName,
    required this.scannedAt,
    required this.decision,
    required this.mode,
    required this.foodCodeId,
    this.notes,
    this.wasSaved = false,
  });

  /// Creates a [ScanHistoryEntry] instance from a JSON map.
  factory ScanHistoryEntry.fromJson(Map<String, dynamic> json) {
    return ScanHistoryEntry(
      id: json['id'] as String,
      barcode: json['barcode'] as String,
      productName: json['productName'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      decision: DecisionResult.values.firstWhere(
        (e) => e.name == json['decision'],
        orElse: () => DecisionResult.yellow,
      ),
      mode: DecisionMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => DecisionMode.buy,
      ),
      foodCodeId: json['foodCodeId'] as String,
      notes: json['notes'] as String?,
      wasSaved: json['wasSaved'] as bool? ?? false,
    );
  }

  /// Converts this [ScanHistoryEntry] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'productName': productName,
      'scannedAt': scannedAt.toIso8601String(),
      'decision': decision.name,
      'mode': mode.name,
      'foodCodeId': foodCodeId,
      'notes': notes,
      'wasSaved': wasSaved,
    };
  }

  /// Creates a [ScanHistoryEntry] instance from a database map.
  factory ScanHistoryEntry.fromMap(Map<String, dynamic> map) {
    return ScanHistoryEntry(
      id: map['id'] as String,
      barcode: map['barcode'] as String,
      productName: map['productName'] as String?,
      scannedAt: DateTime.fromMillisecondsSinceEpoch(map['scannedAt'] as int),
      decision: DecisionResult.values.firstWhere(
        (e) => e.name == map['decision'],
        orElse: () => DecisionResult.yellow,
      ),
      mode: DecisionMode.values.firstWhere(
        (e) => e.name == map['mode'],
        orElse: () => DecisionMode.buy,
      ),
      foodCodeId: map['foodCodeId'] as String,
      notes: map['notes'] as String?,
      wasSaved: (map['wasSaved'] as int) == 1,
    );
  }

  /// Converts this [ScanHistoryEntry] instance to a database map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'productName': productName,
      'scannedAt': scannedAt.millisecondsSinceEpoch,
      'decision': decision.name,
      'mode': mode.name,
      'foodCodeId': foodCodeId,
      'notes': notes,
      'wasSaved': wasSaved ? 1 : 0,
    };
  }
}
