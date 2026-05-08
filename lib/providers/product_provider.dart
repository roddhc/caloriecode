import 'package:flutter/foundation.dart';
import 'package:caloriecode/models/product.dart';
import 'package:caloriecode/services/product_data_service.dart';

enum ProductState { initial, loading, success, error }

class ProductProvider extends ChangeNotifier {
  final ProductDataService _productDataService;

  Product? _product;
  ProductState _state = ProductState.initial;
  String? _errorMessage;

  ProductProvider(this._productDataService);

  Product? get product => _product;
  ProductState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProduct(String barcode) async {
    _state = ProductState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedProduct = await _productDataService.fetchProduct(barcode);
      if (fetchedProduct != null) {
        _product = fetchedProduct;
        _state = ProductState.success;
      } else {
        _state = ProductState.error;
        _errorMessage = 'Product not found';
      }
    } catch (e) {
      _state = ProductState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void clearProduct() {
    _product = null;
    _state = ProductState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
