import 'package:openfoodfacts/openfoodfacts.dart';
import '../models/product.dart' as app_product;
import '../models/nutrition_info.dart';
import 'product_data_service.dart';

class OpenFoodFactsService implements ProductDataService {
  OpenFoodFactsService() {
    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'CalorieCode',
      version: '1.0',
      system: 'Android/iOS',
      url: 'https://github.com/roddhc/caloriecode',
    );
  }

  @override
  Future<app_product.Product?> fetchProduct(String barcode) async {
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [
        ProductField.BARCODE,
        ProductField.NAME,
        ProductField.BRANDS,
        ProductField.INGREDIENTS_TEXT,
        ProductField.NUTRIMENTS,
        ProductField.ALLERGENS,
      ],
      version: ProductQueryVersion.v3,
    );

    try {
      final ProductResultV3 result =
          await OpenFoodAPIClient.getProductV3(configuration);

      if (result.status != ProductResultV3.statusSuccess ||
          result.product == null) {
        return null;
      }

      final offProduct = result.product!;

      // Map OFF Nutriment to our app NutritionInfo
      NutritionInfo? nutritionInfo;
      if (offProduct.nutriments != null) {
        final nutriments = offProduct.nutriments!;
        nutritionInfo = NutritionInfo(
          caloriesPer100g: nutriments.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams),
          caloriePerServing: nutriments.getValue(Nutrient.energyKCal, PerSize.serving),
          servingSize: offProduct.servingSize,
          sugar: nutriments.getValue(Nutrient.sugars, PerSize.serving) ??
              nutriments.getValue(Nutrient.sugars, PerSize.oneHundredGrams),
          fat: nutriments.getValue(Nutrient.fat, PerSize.serving) ??
              nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams),
          protein: nutriments.getValue(Nutrient.proteins, PerSize.serving) ??
              nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams),
          carbs: nutriments.getValue(Nutrient.carbohydrates, PerSize.serving) ??
              nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams),
          fiber: nutriments.getValue(Nutrient.fiber, PerSize.serving) ??
              nutriments.getValue(Nutrient.fiber, PerSize.oneHundredGrams),
          salt: nutriments.getValue(Nutrient.salt, PerSize.serving) ??
              nutriments.getValue(Nutrient.salt, PerSize.oneHundredGrams),
        );
      }

      // Map ingredients
      List<String>? ingredientsList;
      if (offProduct.ingredientsText != null) {
        ingredientsList = offProduct.ingredientsText!
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      // Map allergens
      List<String>? allergensList;
      if (offProduct.allergens?.names != null) {
        allergensList = offProduct.allergens!.names!
            .map((e) => e.trim().toLowerCase().replaceAll('en:', ''))
            .toList();
      }

      return app_product.Product(
        barcode: barcode,
        name: offProduct.productName,
        brand: offProduct.brands,
        nutrition: nutritionInfo,
        ingredients: ingredientsList,
        allergens: allergensList,
        source: app_product.ProductSource.offApi,
        cachedAt: DateTime.now(),
      );
    } catch (e) {
      // In a real app, we might want to log this or return a specific error
      print('Error fetching product from OpenFoodFacts: $e');
      return null;
    }
  }
}
