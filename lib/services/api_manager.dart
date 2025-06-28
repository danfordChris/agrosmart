import 'dart:convert';

import 'package:agrosmart/Constants/api_urls.dart';
import 'package:agrosmart/models/user_info_model.dart';
import 'package:agrosmart/repositories/user_info_repository.dart';
import 'package:agrosmart/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:agrosmart/services/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ipf_flutter_starter_pack/services.dart';

class APIManager extends BaseAPIManager {
  APIManager._() : super(_currentURL, _authorization);
  static APIManager get instance => APIManager._();

  static const String _localURL = "http://127.0.0.1:8000/api/v1";
  static const String _baseURL = "<Insert URL Here>/api/v1";
  static const String _releaseURL = "<Insert URL Here>/api/v1";
  static const String _currentURL = kDebugMode ? _localURL : _releaseURL;

  static Future<Map<String, String>?> get _authorization async {
    Preferences preferences = Preferences.instance;
    String? token = await preferences.fetch(PrefKeys.apiToken);
    if (token == null) return null;
    return {"Authorization": "Token $token"};
  }

  _getToken() async {
    return await Preferences.instance.apiToken;
  }

  Future<UserInfoModel> signUp(
    BuildContext context, {
    UserInfoModel? userData,
  }) async {
    final api = ApiUrls.signUp;
    final headers = {"Content-Type": "application/json"};
    final body = userData!.toJsonData();

    try {
      final response = await http.post(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode <= 299) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final data = responseBody['user'];
        final token = responseBody['token'];

        UserInfoModel userData = UserInfoModel.fromJson(data);
        UserInfoRepository.instance.save(userData);

        Preferences.instance.save(PrefKeys.apiToken, token);
        final user = await UserInfoRepository.instance.all;
        if (user.isNotEmpty) {
          SessionManager.instance.setUserInfo(user.first);
        }
        debugPrint("User Data obtained : $userData");

        return userData;
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        Scenery.showError("${response.statusCode}: Failed to register ");
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        Scenery.showError("Failed to register, please retry ");
        debugPrint('Network error: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
      debugPrint('Unexpected error: $e');
      Scenery.showError("Failed to register, please retry ");
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<UserInfoModel> updateProfile(
    BuildContext context, {
    UserInfoModel? userData,
  }) async {
    final api = ApiUrls.updateProfile;
    final accessTokenFromPref = await _getToken();
    debugPrint("Token in updating $accessTokenFromPref");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token $accessTokenFromPref",
    };
    final body = userData!.toJson;

    try {
      final response = await http.put(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode <= 299) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final data = responseBody;

        UserInfoModel userData = UserInfoModel.fromJson(data);
        UserInfoRepository.instance.save(userData);

        final user = await UserInfoRepository.instance.all;
        if (user.isNotEmpty) {
          SessionManager.instance.setUserInfo(user.first);
        }

        debugPrint("User Data obtained : $userData");

        Navigator.pop(context);

        return userData;
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        Scenery.showError("${response.statusCode}: Failed to update profile ");
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        Scenery.showError("Failed to update profile , please retry ");
        debugPrint('Network error: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
      debugPrint('Unexpected error: $e');
      Scenery.showError("Failed to update profile , please retry ");
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<UserInfoModel> login(
    BuildContext context, {
    UserInfoModel? userData,
  }) async {
    final api = ApiUrls.login;
    final headers = {"Content-Type": "application/json"};
    final body = userData!.toLoginData();

    try {
      final response = await http.post(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode <= 299) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final data = responseBody['user'];
        final token = responseBody['token'];

        UserInfoModel userData = UserInfoModel.fromJson(data);
        UserInfoRepository.instance.save(userData);

        Preferences.instance.save(PrefKeys.apiToken, token);

        final wtoken = await Preferences.instance.apiToken;

        debugPrint("the saved token is $wtoken");

        final token2 = await _getToken();
        debugPrint("The token from function is $token2");

        final user = await UserInfoRepository.instance.all;
        if (user.isNotEmpty) {
          SessionManager.instance.setUserInfo(user.first);
        }

        debugPrint("User Data obtained : $userData");

        return userData;
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        Scenery.showError("${response.statusCode}: Failed to login ");
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        Scenery.showError("Failed to login, please retry ");
        debugPrint('Network error: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
      debugPrint('Unexpected error: $e');
      Scenery.showError("Failed to login, please retry ");
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<dynamic> resetPassword(
    BuildContext context, {
    String? userData,
  }) async {
    final api = ApiUrls.resetPassword;
    final accessTokenFromPref = await _getToken();
    debugPrint("Token in updating $accessTokenFromPref");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token $accessTokenFromPref",
    };
    final body = {"email": userData};

    try {
      final response = await http.post(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode <= 299) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final data = responseBody['message'];

        Scenery.showToast(data);

        return true;
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        Scenery.showError("${response.statusCode}: Failed to login ");
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        Scenery.showError("Failed to login, please retry ");
        debugPrint('Network error: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
      debugPrint('Unexpected error: $e');
      Scenery.showError("Failed to login, please retry ");
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
