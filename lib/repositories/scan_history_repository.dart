import 'package:caloriecode/models/scan_history_entry.dart';

/// Interface for accessing scan history.
abstract class ScanHistoryRepository {
  /// Gets recent scan history entries.
  Future<List<ScanHistoryEntry>> getRecentScans({int limit = 50});

  /// Adds a new scan history entry.
  Future<void> addScan(ScanHistoryEntry entry);

  /// Clears all scan history.
  Future<void> clearHistory();
}
