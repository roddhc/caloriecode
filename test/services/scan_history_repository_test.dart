import 'package:flutter_test/flutter_test.dart';
import 'package:caloriecode/models/scan_history_entry.dart';
import 'package:caloriecode/models/decision.dart';
import 'package:caloriecode/services/scan_history_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late ScanHistoryRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    repository = ScanHistoryRepository.instance;
    // Overriding the db path to use an in-memory db for testing
    final db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE scan_history(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              barcode TEXT NOT NULL,
              product_name TEXT NOT NULL,
              scanned_at TEXT NOT NULL,
              decision TEXT NOT NULL,
              mode TEXT NOT NULL,
              food_code_id TEXT NOT NULL,
              created_at TEXT NOT NULL
            )
          ''');
        },
      ),
    );
    repository.setDatabaseForTesting(db);
  });

  tearDown(() async {
    await repository.clearHistory();
    // Close it if necessary or wait for next setUp
  });

  test('recordScan should insert an entry and return the new ID', () async {
    final id = await repository.recordScan(
      barcode: '123456789',
      productName: 'Test Product',
      decision: 'green',
      mode: 'buy',
      foodCodeId: 'code-1',
    );

    expect(id, isPositive);

    final total = await repository.getTotalScans();
    expect(total, 1);
  });

  test('getRecentScans should return correct limits ordered by scanned_at DESC', () async {
    await repository.recordScan(
      barcode: '111',
      productName: 'P1',
      decision: 'green',
      mode: 'buy',
      foodCodeId: 'code-1',
    );
    await Future.delayed(const Duration(milliseconds: 100)); // ensure time diff
    await repository.recordScan(
      barcode: '222',
      productName: 'P2',
      decision: 'red',
      mode: 'eat',
      foodCodeId: 'code-2',
    );

    final scans = await repository.getRecentScans(1);
    expect(scans.length, 1);
    expect(scans.first.barcode, '222'); // The most recent one

    final allScans = await repository.getRecentScans(10);
    expect(allScans.length, 2);
    expect(allScans[0].barcode, '222');
    expect(allScans[1].barcode, '111');
  });

  test('getScansByDateRange should filter by dates correctly', () async {
    final now = DateTime.now();

    // Insert old record
    final db = await repository.database;
    await db.insert('scan_history', {
      'barcode': 'old',
      'product_name': 'Old',
      'scanned_at': now.subtract(const Duration(days: 10)).toIso8601String(),
      'decision': 'green',
      'mode': 'buy',
      'food_code_id': 'code',
      'created_at': now.toIso8601String(),
    });

    // Insert new record
    await db.insert('scan_history', {
      'barcode': 'new',
      'product_name': 'New',
      'scanned_at': now.subtract(const Duration(days: 1)).toIso8601String(),
      'decision': 'green',
      'mode': 'buy',
      'food_code_id': 'code',
      'created_at': now.toIso8601String(),
    });

    final results = await repository.getScansByDateRange(
      now.subtract(const Duration(days: 5)),
      now,
    );

    expect(results.length, 1);
    expect(results.first.barcode, 'new');
  });

  test('getScansByDecision should filter correctly', () async {
    await repository.recordScan(
      barcode: '111',
      productName: 'Green Product',
      decision: 'green',
      mode: 'buy',
      foodCodeId: 'code-1',
    );
    await repository.recordScan(
      barcode: '222',
      productName: 'Red Product',
      decision: 'red',
      mode: 'eat',
      foodCodeId: 'code-1',
    );

    final greens = await repository.getScansByDecision('green');
    expect(greens.length, 1);
    expect(greens.first.barcode, '111');
  });

  test('bulkRestore should use batch inserts properly', () async {
    final entries = [
      ScanHistoryEntry(
        id: '1',
        barcode: 'B1',
        productName: 'Product 1',
        scannedAt: DateTime.now(),
        decision: DecisionResult.green,
        mode: DecisionMode.buy,
        foodCodeId: 'code',
      ),
      ScanHistoryEntry(
        id: '2',
        barcode: 'B2',
        productName: 'Product 2',
        scannedAt: DateTime.now(),
        decision: DecisionResult.red,
        mode: DecisionMode.eat,
        foodCodeId: 'code',
      ),
    ];

    await repository.bulkRestore(entries);

    final total = await repository.getTotalScans();
    expect(total, 2);
  });

  test('clearHistory should remove all scans', () async {
     await repository.recordScan(
      barcode: '111',
      productName: 'P1',
      decision: 'green',
      mode: 'buy',
      foodCodeId: 'code-1',
    );
    expect(await repository.getTotalScans(), 1);

    await repository.clearHistory();
    expect(await repository.getTotalScans(), 0);
  });
}
