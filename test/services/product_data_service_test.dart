import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caloriecode/models/product.dart';
import 'package:caloriecode/services/product_data_service.dart';

import 'product_data_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    ProductDataService.setDioForTesting(mockDio);

    // Setup mock shared preferences
    SharedPreferences.setMockInitialValues({});
  });

  group('ProductDataService caching', () {
    test('cacheProduct saves to SharedPreferences and getCachedProduct retrieves it', () async {
      final product = Product(
        barcode: '12345',
        name: 'Test Product',
        source: ProductSource.offApi,
        cachedAt: DateTime.now().subtract(const Duration(hours: 1)),
      );

      await ProductDataService.cacheProduct(product);

      final cached = await ProductDataService.getCachedProduct('12345');
      expect(cached, isNotNull);
      expect(cached!.name, 'Test Product');
      expect(cached.barcode, '12345');
    });

    test('getCachedProduct returns null if cache is older than 24 hours', () async {
      final product = Product(
        barcode: 'old_cache',
        name: 'Old Product',
        source: ProductSource.offApi,
        cachedAt: DateTime.now().subtract(const Duration(hours: 25)),
      );

      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(product.toJson());
      await prefs.setString('product_cache_old_cache', jsonString);

      final cached = await ProductDataService.getCachedProduct('old_cache');
      expect(cached, isNull);
    });
  });

  group('ProductDataService USDA API Fallback', () {
    // Note: To completely test OFF API we'd need to mock the global static methods or HTTP.
    // For this test, we assume OFF API will timeout/fail (since it's making a real call to nowhere/invalid barcode)
    // and we will test that USDA fallback kicks in.

    test('fetchProductByBarcode falls back to USDA when OFF fails', () async {
      // Mock Dio for USDA API
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'foods': [
            {
              'description': 'USDA Apple',
              'brandOwner': 'Nature',
              'ingredients': 'Apple',
            }
          ]
        },
      ));

      // Use an invalid barcode so OFF API throws or returns null quickly
      final result = await ProductDataService.fetchProductByBarcode('invalid_barcode_to_force_fallback');

      expect(result, isNotNull);
      expect(result!.source, ProductSource.usdaApi);
      expect(result.name, 'USDA Apple');
      expect(result.brand, 'Nature');
    });
  });

  group('ProductDataService Cache Fallback', () {
    test('fetchProductByBarcode falls back to cache when both APIs fail', () async {
      // Setup cache
      final product = Product(
        barcode: 'cache_only',
        name: 'Cached Item',
        source: ProductSource.offApi,
        cachedAt: DateTime.now(),
      );
      await ProductDataService.cacheProduct(product);

      // Mock Dio for USDA API to throw an error
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      final result = await ProductDataService.fetchProductByBarcode('cache_only');

      expect(result, isNotNull);
      expect(result!.name, 'Cached Item');
    });
  });
}
