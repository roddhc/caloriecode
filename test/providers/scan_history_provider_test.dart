import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:caloriecode/providers/scan_history_provider.dart';
import '../utils/test_data.dart';
import '../utils/test_data.mocks.dart';

void main() {
  late MockScanHistoryRepository mockRepo;
  late ScanHistoryProvider provider;

  setUp(() {
    mockRepo = MockScanHistoryRepository();
    provider = ScanHistoryProvider(mockRepo);
  });

  group('ScanHistoryProvider', () {
    test('initial state is correct', () {
      expect(provider.history, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });

    test('loadRecentScans loads history from repo', () async {
      final scans = [TestData.mockScanHistoryEntry];
      when(mockRepo.getRecentScans(limit: anyNamed('limit')))
          .thenAnswer((_) async => scans);

      final future = provider.loadRecentScans();

      expect(provider.isLoading, isTrue);

      await future;

      expect(provider.isLoading, isFalse);
      expect(provider.history, equals(scans));
      verify(mockRepo.getRecentScans()).called(1);
    });

    test('addScan adds entry to repo and local list', () async {
      when(mockRepo.addScan(TestData.mockScanHistoryEntry))
          .thenAnswer((_) async => {});

      await provider.addScan(TestData.mockScanHistoryEntry);

      expect(provider.history, contains(TestData.mockScanHistoryEntry));
      verify(mockRepo.addScan(TestData.mockScanHistoryEntry)).called(1);
    });

    test('clearHistory clears repo and local list', () async {
      // Setup some initial state
      when(mockRepo.getRecentScans(limit: anyNamed('limit')))
          .thenAnswer((_) async => [TestData.mockScanHistoryEntry]);
      await provider.loadRecentScans();
      expect(provider.history, isNotEmpty);

      // Now clear
      when(mockRepo.clearHistory()).thenAnswer((_) async => {});

      await provider.clearHistory();

      expect(provider.history, isEmpty);
      verify(mockRepo.clearHistory()).called(1);
    });

    test('error handling in loadRecentScans', () async {
      when(mockRepo.getRecentScans(limit: anyNamed('limit')))
          .thenThrow(Exception('DB Error'));

      await provider.loadRecentScans();

      expect(provider.isLoading, isFalse);
      expect(provider.history, isEmpty);
      expect(provider.errorMessage, contains('DB Error'));
    });
  });
}
