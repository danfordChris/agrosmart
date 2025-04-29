// cart_provider.dart
import 'package:flutter/foundation.dart';
import 'package:agrosmart/models/crop_products.dart';

class CartProvider with ChangeNotifier {
  final List<CropProduct> _cartItems = [];

  List<CropProduct> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void addToCart(CropProduct product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(CropProduct product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}