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

  static Future<Map<String, dynamic>> getpredictedCrops(
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
        return responseBody;
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
