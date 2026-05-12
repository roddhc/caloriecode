import 'package:caloriecode/models/product.dart';
import 'package:caloriecode/models/nutrition_info.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:caloriecode/models/decision.dart';
import 'package:caloriecode/models/scan_history_entry.dart';
import 'package:mockito/annotations.dart';
import 'package:caloriecode/services/product_data_service.dart';
import 'package:caloriecode/services/food_code_service.dart';
import 'package:caloriecode/repositories/scan_history_repository.dart';
import 'package:caloriecode/providers/food_code_provider.dart';
import 'package:caloriecode/providers/scan_history_provider.dart';

@GenerateMocks([ProductDataService, FoodCodeService, ScanHistoryRepository, FoodCodeProvider, ScanHistoryProvider])
class TestData {
  static const testBarcode = '123456789012';

  static final mockNutrition = NutritionInfo(
    caloriesPer100g: 250.0,
    sugar: 10.5,
    salt: 1.2,
    fat: 5.0,
    protein: 3.0,
  );

  static final mockProductGreen = Product(
    barcode: testBarcode,
    name: 'Healthy Snack',
    brand: 'Nature Co',
    nutrition: mockNutrition,
    ingredients: ['Oats', 'Honey', 'Almonds'],
    allergens: ['Nuts'],
    source: ProductSource.offApi,
  );

  static final mockFoodCode = FoodCode(
    id: 'fc-1',
    name: 'Low Sugar Diet',
    description: 'A diet focusing on low sugar intake',
    isStarter: true,
    maxSugarPerServing: 5.0,
    isActive: true,
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );

  static final mockDecision = Decision(
    productBarcode: testBarcode,
    result: DecisionResult.green,
    explanation: 'Meets all criteria for Low Sugar Diet',
    confidence: 0.95,
    foodCodeId: 'fc-1',
    mode: DecisionMode.buy,
    createdAt: DateTime(2023, 1, 2),
  );

  static final mockScanHistoryEntry = ScanHistoryEntry(
    id: 'sh-1',
    barcode: testBarcode,
    productName: 'Healthy Snack',
    scannedAt: DateTime(2023, 1, 2),
    decision: DecisionResult.green,
    mode: DecisionMode.buy,
    foodCodeId: 'fc-1',
    wasSaved: true,
  );
}
