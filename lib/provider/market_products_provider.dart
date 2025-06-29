// lib/providers/auth_provider.dart
import 'package:agrosmart/models/user_info_model.dart';
import 'package:agrosmart/screen/dasboard.dart';
import 'package:agrosmart/services/api_manager.dart';
import 'package:flutter/material.dart';

class MarketProductsProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getProducts(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await APIManager.instance.getmarketProducts(context);

      _isLoading = false;
      _errorMessage = null;
      // Navigate to dashboard on success
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Dashboard()),
      // );
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signup(UserInfoModel? userInfo, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (userInfo!.last_name == null ||
          userInfo.first_name == null ||
          userInfo.email == null ||
          userInfo.password == null) {
        throw Exception('Please fill all fields');
      }

      await APIManager.instance.signUp(userData: userInfo, context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Replace with actual password reset logic
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid email');
      }
      await APIManager.instance.resetPassword(context, userData: email);

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfile(
    UserInfoModel? userInfo,
    BuildContext context,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      await APIManager.instance.updateProfile(userData: userInfo, context);

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Dashboard()),
      // );

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
