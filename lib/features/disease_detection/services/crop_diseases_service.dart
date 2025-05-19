import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:agrosmart/models/crop_diseases_model.dart';
import 'package:agrosmart/provider/crop_prediction_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CropDetectionService {
  // This will be replaced with actual API call to your AI model
  Future<CropDiseaseResult> detectDisease(File imageFile) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock data for now
    // In production, you would send the image to your AI model API
    // and process the response
    return MockData.getRandomResult();
  }

  // Will be implemented when actual AI model is available
  Future<void> uploadImageToAI(File imageFile) async {
    // Implementation will depend on your AI model's API
  }
}

class CropPredictionService {
  static const String apiUrl =
      'https://grizzly-magnetic-lionfish.ngrok-free.app/recommend/';

  Future<Map<String, dynamic>> getpredictedCrops(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        debugPrint("Prediction result: $responseBody");
        final data = {
          "location": {
            "latitude": -6.097185849858731,
            "longitude": 35.77357265625,
            "address": "N/A",
          },
          "soil_properties": {
            "Nitrogen Total (0-20cm)": 0.5,
            "Potassium Extractable (0-20cm)": 163.0,
            "Phosphorus Extractable (0-20cm)": 5.0,
            "Soil pH (0-20cm)": 5.9,
            "Bulk Density (0-20cm)": 1.48,
            "Land Cover (2019)":
                "Cultivated and managed vegetation/agriculture (cropland)",
            "Cation Exchange Capacity (0-20cm)": 8.0,
          },
          "weather": {"temperature": 25.16, "humidity": 50, "rainfall": 0},
          "ai_recommendations": {"predicted_crop": "Matango"},
          "explanation":
              "Matango yanahitaji udongo wenye rutuba ya kutosha na pH kati ya 6.0–6.8. Msimu mzuri wa kupanda ni Oktoba hadi Januari.",
        };

        return data;
      } else {
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to get prediction details');
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception("Something went wrong");
    }
  }
}
