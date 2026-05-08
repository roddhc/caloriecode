import 'package:flutter/foundation.dart';
import 'package:caloriecode/models/scan_history_entry.dart';
import 'package:caloriecode/repositories/scan_history_repository.dart';

class ScanHistoryProvider extends ChangeNotifier {
  final ScanHistoryRepository _repository;

  List<ScanHistoryEntry> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  ScanHistoryProvider(this._repository);

  List<ScanHistoryEntry> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRecentScans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _history = await _repository.getRecentScans();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addScan(ScanHistoryEntry entry) async {
    try {
      await _repository.addScan(entry);
      _history.insert(0, entry);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    try {
      await _repository.clearHistory();
      _history.clear();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
