// cart_provider.dart
import 'package:agrosmart/models/market_product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:agrosmart/models/crop_products.dart';

class CartProvider with ChangeNotifier {
  final List<MarketProductModel> _cartItems = [];

  List<MarketProductModel> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (int.tryParse(item.price!) ?? 0),
    );
  }

  void addToCart(MarketProductModel product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(MarketProductModel product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
