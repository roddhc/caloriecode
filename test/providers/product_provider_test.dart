import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:caloriecode/providers/product_provider.dart';
import '../utils/test_data.dart';
import '../utils/test_data.mocks.dart';

void main() {
  late MockProductDataService mockService;
  late ProductProvider provider;

  setUp(() {
    mockService = MockProductDataService();
    provider = ProductProvider(mockService);
  });

  group('ProductProvider', () {
    test('initial state is correct', () {
      expect(provider.state, ProductState.initial);
      expect(provider.product, isNull);
      expect(provider.errorMessage, isNull);
    });

    test('fetchProduct sets success state on valid product', () async {
      when(mockService.fetchProduct(TestData.testBarcode))
          .thenAnswer((_) async => TestData.mockProductGreen);

      final future = provider.fetchProduct(TestData.testBarcode);

      expect(provider.state, ProductState.loading);

      await future;

      expect(provider.state, ProductState.success);
      expect(provider.product, equals(TestData.mockProductGreen));
      verify(mockService.fetchProduct(TestData.testBarcode)).called(1);
    });

    test('fetchProduct sets error state on null product', () async {
      when(mockService.fetchProduct('invalid'))
          .thenAnswer((_) async => null);

      await provider.fetchProduct('invalid');

      expect(provider.state, ProductState.error);
      expect(provider.product, isNull);
      expect(provider.errorMessage, 'Product not found');
    });

    test('fetchProduct sets error state on exception', () async {
      when(mockService.fetchProduct(any))
          .thenThrow(Exception('Network error'));

      await provider.fetchProduct(TestData.testBarcode);

      expect(provider.state, ProductState.error);
      expect(provider.product, isNull);
      expect(provider.errorMessage, contains('Network error'));
    });

    test('clearProduct resets state', () async {
      // Setup successful state first
      when(mockService.fetchProduct(TestData.testBarcode))
          .thenAnswer((_) async => TestData.mockProductGreen);
      await provider.fetchProduct(TestData.testBarcode);

      // Now clear
      provider.clearProduct();

      expect(provider.state, ProductState.initial);
      expect(provider.product, isNull);
      expect(provider.errorMessage, isNull);
    });
  });
}
