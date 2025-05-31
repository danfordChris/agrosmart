import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:agrosmart/Constants/agrosmart_list.dart';
import 'package:agrosmart/models/crop_diseases_model.dart';
import 'package:agrosmart/provider/crop_prediction_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CropDetectionService {
  CropDetectionService._privateConstructor();
  static final CropDetectionService _instance =
      CropDetectionService._privateConstructor();
  static CropDetectionService get instance => _instance;

  // This will be replaced with actual API call to your AI model
  Future<CropDisease> detectDisease(File imageFile) async {
    final apiUrl = 'https://chat.deepseek.com/api/diseases/';

    try {
      print('RESPONSE>>>');
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add the file as multipart
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('RESPONSE>>>222');
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      print('RESPONSE>>>2');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        debugPrint("Disease detection result: $responseBody");

        if (responseBody.containsKey('prediction')) {
          final prediction = responseBody['prediction'];
          final recommendations = responseBody['recommendations'] ?? {};
          final description = recommendations['description'] ?? '';
          final treatment = recommendations['treatment'] ?? [];
          final prevention = recommendations['prevention'] ?? [];

          return CropDisease(
            name: prediction,
            description: description,
            treatmentSuggestion: treatment.join(', '),
            preventionSuggestion: prevention.join(', '),
          );
        } else {
          throw Exception('Prediction not found in response');
        }
      } else if (response.statusCode == 403) {
        final responseBody = AgrosmartList.cropScale;
        debugPrint("Disease detection fallback result: $responseBody");

        if (responseBody.containsKey('prediction')) {
          final prediction = responseBody['prediction'];
          final recommendations = responseBody['recommendations'] ?? {};
          final description = recommendations['description'] ?? '';
          final treatment = recommendations['treatment'] ?? [];
          final prevention = recommendations['prevention'] ?? [];

          return CropDisease(
            name: prediction,
            description: description,
            treatmentSuggestion: treatment.join(', '),
            preventionSuggestion: prevention.join(', '),
          );
        } else {
          throw Exception('Fallback prediction not found in response');
        }
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to get prediction details');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception("Something went wrong");
    }
  }

  // Will be implemented when actual AI model is available
  Future<void> uploadImageToAI(File imageFile) async {
    // Implementation will depend on your AI model's API
  }
}

class CropPredictionService {
  static const String apiUrl =
      'https://grizzly-magnetic-lionfish.ngrok-free.app/recommend/';
  // 'http://example.com';

  Future<Map<String, dynamic>> getpredictedCrops(
    Map<String, dynamic> payload,
  ) async {
    print("DATA LOADING");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        debugPrint("Prediction result: $responseBody");

        if (responseBody.containsKey('recommendations')) {
          final recommendations = responseBody['recommendations'];
          if (recommendations is Map && recommendations.isNotEmpty) {
            responseBody['ai_recommendations'] = {
              'predicted_crop': recommendations.keys.first,
            };
          }
        }
        final data1 = jsonEncode({
          "location": {
            "latitude": -5.0721976,
            "longitude": 39.0993457,
            "address": "N/A",
          },
          "soil_properties": {
            "Nitrogen Total (0-20cm)": 1.0,
            "Potassium Extractable (0-20cm)": 108.9,
            "Phosphorus Extractable (0-20cm)": 10.0,
            "Soil pH (0-20cm)": 6.4,
            "Bulk Density (0-20cm)": 1.31,
            "Land Cover (2019)": "Urban / built up",
            "Cation Exchange Capacity (0-20cm)": 8.0,
          },
          "weather": {"temperature": 26.24, "humidity": 84, "rainfall": 0},
          "recommendations": {
            "Matango": {
              "explanation":
                  "Matango yanahitaji udongo wenye rutuba ya kutosha na pH kati ya 6.0–6.8. Msimu mzuri wa kupanda ni Oktoba hadi Januari.",
              "score": 0.5788,
            },
            "Matikiti": {
              "explanation":
                  "Matikiti yanapendelea udongo mwepesi na joto la wastani, pH 6.0–6.8. Msimu mzuri wa kupanda ni Oktoba hadi Desemba.",
              "score": 0.4196,
            },
          },
        });
        final decodeData = jsonDecode(data1);

        return decodeData;
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to get prediction details');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      throw Exception("Something went wrong");
    }
  }
}
