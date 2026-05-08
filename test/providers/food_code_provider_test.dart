import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:caloriecode/providers/food_code_provider.dart';
import '../utils/test_data.dart';
import '../utils/test_data.mocks.dart';

void main() {
  late MockFoodCodeService mockService;
  late FoodCodeProvider provider;

  setUp(() {
    mockService = MockFoodCodeService();
    provider = FoodCodeProvider(mockService);
  });

  group('FoodCodeProvider', () {
    test('initial state is correct', () {
      expect(provider.activeFoodCode, isNull);
      expect(provider.allCodes, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });

    test('loadAllCodes loads codes and sets active code if empty', () async {
      final codes = [TestData.mockFoodCode];
      when(mockService.getAllFoodCodes()).thenAnswer((_) async => codes);

      final future = provider.loadAllCodes();

      expect(provider.isLoading, isTrue);

      await future;

      expect(provider.isLoading, isFalse);
      expect(provider.allCodes, equals(codes));
      expect(provider.activeFoodCode, equals(TestData.mockFoodCode));
      verify(mockService.getAllFoodCodes()).called(1);
    });

    test('loadAllCodes handles errors', () async {
      when(mockService.getAllFoodCodes()).thenThrow(Exception('DB Error'));

      await provider.loadAllCodes();

      expect(provider.isLoading, isFalse);
      expect(provider.allCodes, isEmpty);
      expect(provider.errorMessage, contains('DB Error'));
    });

    test('setActiveFoodCode updates active code', () async {
      when(mockService.getFoodCode(TestData.mockFoodCode.id))
          .thenAnswer((_) async => TestData.mockFoodCode);

      await provider.setActiveFoodCode(TestData.mockFoodCode.id);

      expect(provider.activeFoodCode, equals(TestData.mockFoodCode));
      verify(mockService.getFoodCode(TestData.mockFoodCode.id)).called(1);
    });

    test('setActiveFoodCode handles null code', () async {
      when(mockService.getFoodCode('invalid'))
          .thenAnswer((_) async => null);

      await provider.setActiveFoodCode('invalid');

      expect(provider.activeFoodCode, isNull); // Assuming it was initially null
    });
  });
}
