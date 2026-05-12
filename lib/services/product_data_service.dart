import 'package:caloriecode/models/product.dart';

/// Interface for fetching product data.
abstract class ProductDataService {
  /// Fetches a product by its barcode.
  Future<Product?> fetchProduct(String barcode);
}
