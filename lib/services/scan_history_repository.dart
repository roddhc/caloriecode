import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:caloriecode/models/scan_history_entry.dart';
import 'package:caloriecode/models/decision.dart';
import 'package:caloriecode/utils/constants.dart';

/// Repository for persisting scan history in SQLite.
class ScanHistoryRepository {
  /// Private constructor for singleton pattern.
  ScanHistoryRepository._privateConstructor();

  /// The single instance of [ScanHistoryRepository].
  static final ScanHistoryRepository instance =
      ScanHistoryRepository._privateConstructor();

  Database? _database;

  /// Lazy initialization of the database.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Override the database for testing purposes.
  void setDatabaseForTesting(Database mockDb) {
    _database = mockDb;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), Constants.databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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
  }

  /// Records a new scan in the database.
  Future<int> recordScan({
    required String barcode,
    required String productName,
    required String decision,
    required String mode,
    required String foodCodeId,
  }) async {
    try {
      final Database db = await database;
      final DateTime now = DateTime.now();

      final int id = await db.insert(
        'scan_history',
        {
          'barcode': barcode,
          'product_name': productName,
          'scanned_at': now.toIso8601String(),
          'decision': decision,
          'mode': mode,
          'food_code_id': foodCodeId,
          'created_at': now.toIso8601String(),
        },
      );
      return id;
    } catch (e) {
      // Re-throw database exceptions
      rethrow;
    }
  }

  /// Retrieves the most recent scans.
  Future<List<ScanHistoryEntry>> getRecentScans(int limit) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'scan_history',
        orderBy: 'scanned_at DESC',
        limit: limit,
      );

      return maps.map((map) => _mapToEntry(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves scans within a specific date range.
  Future<List<ScanHistoryEntry>> getScansByDateRange(
      DateTime from, DateTime to) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'scan_history',
        where: 'scanned_at >= ? AND scanned_at <= ?',
        whereArgs: [from.toIso8601String(), to.toIso8601String()],
        orderBy: 'scanned_at DESC',
      );

      return maps.map((map) => _mapToEntry(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves scans with a specific decision result.
  Future<List<ScanHistoryEntry>> getScansByDecision(String decision) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'scan_history',
        where: 'decision = ?',
        whereArgs: [decision],
        orderBy: 'scanned_at DESC',
      );

      return maps.map((map) => _mapToEntry(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Bulk restores a list of scan history entries using a batch operation.
  Future<void> bulkRestore(List<ScanHistoryEntry> entries) async {
    try {
      final Database db = await database;
      final Batch batch = db.batch();

      for (final entry in entries) {
        batch.insert(
          'scan_history',
          {
            'barcode': entry.barcode,
            'product_name': entry.productName ?? '',
            'scanned_at': entry.scannedAt.toIso8601String(),
            'decision': entry.decision.name,
            'mode': entry.mode.name,
            'food_code_id': entry.foodCodeId,
            'created_at': DateTime.now().toIso8601String(),
          },
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Clears all scan history.
  Future<void> clearHistory() async {
    try {
      final Database db = await database;
      await db.delete('scan_history');
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves the total number of scans.
  Future<int> getTotalScans() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT COUNT(*) FROM scan_history');
      final int count = Sqflite.firstIntValue(result) ?? 0;
      return count;
    } catch (e) {
      rethrow;
    }
  }

  /// Helper to map database rows to [ScanHistoryEntry].
  ScanHistoryEntry _mapToEntry(Map<String, dynamic> map) {
    return ScanHistoryEntry(
      id: map['id'].toString(),
      barcode: map['barcode'] as String,
      productName: map['product_name'] as String,
      scannedAt: DateTime.parse(map['scanned_at'] as String),
      decision: DecisionResult.values.firstWhere(
        (e) => e.name == map['decision'],
        orElse: () => DecisionResult.yellow,
      ),
      mode: DecisionMode.values.firstWhere(
        (e) => e.name == map['mode'],
        orElse: () => DecisionMode.buy,
      ),
      foodCodeId: map['food_code_id'] as String,
      // Since the table schema doesn't include 'notes' or 'was_saved',
      // we provide default values.
      notes: null,
      wasSaved: false,
    );
  }
}
