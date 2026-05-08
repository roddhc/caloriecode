import 'package:flutter/foundation.dart';
import 'package:caloriecode/models/food_code.dart';
import 'package:caloriecode/services/food_code_service.dart';

class FoodCodeProvider extends ChangeNotifier {
  final FoodCodeService _foodCodeService;

  FoodCode? _activeFoodCode;
  List<FoodCode> _allCodes = [];
  bool _isLoading = false;
  String? _errorMessage;

  FoodCodeProvider(this._foodCodeService);

  FoodCode? get activeFoodCode => _activeFoodCode;
  List<FoodCode> get allCodes => _allCodes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllCodes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allCodes = await _foodCodeService.getAllFoodCodes();
      if (_allCodes.isNotEmpty && _activeFoodCode == null) {
         _activeFoodCode = _allCodes.first;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setActiveFoodCode(String id) async {
    try {
      final code = await _foodCodeService.getFoodCode(id);
      if (code != null) {
        _activeFoodCode = code;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
