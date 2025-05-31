import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:agrosmart/services/crop_diseases_service.dart';

class CropPredictionProvider extends ChangeNotifier {
  final CropPredictionService _cropPredictionService = CropPredictionService();
  // Structure to match the provided JSON result
  List<Map<String, dynamic>> predictionResults = [];
  Map<String, dynamic> currentPrediction = {
    "location": {"latitude": null, "longitude": null, "address": "N/A"},
    "soil_properties": {},
    "weather": {},
    "recommendations": {},
  };

  // Getter for all prediction results
  List<Map<String, dynamic>> get predictionResult => predictionResults;

  // Getter for the current prediction
  Map<String, dynamic> get currentPredictions => currentPrediction;

  // Getter for specific sections of current prediction
  double? get latitude => currentPrediction['location']['latitude'];
  double? get longitude => currentPrediction['location']['longitude'];
  String? get address => currentPrediction['location']['address'];

  // Soil properties getters
  Map<String, dynamic> get soilProperties =>
      currentPrediction['soil_properties'];
  double? get nitrogenLevel =>
      currentPrediction['soil_properties']['Nitrogen Total (0-20cm)'];
  double? get potassiumLevel =>
      currentPrediction['soil_properties']['Potassium Extractable (0-20cm)'];
  double? get phosphorusLevel =>
      currentPrediction['soil_properties']['Phosphorus Extractable (0-20cm)'];
  double? get soilPH =>
      currentPrediction['soil_properties']['Soil pH (0-20cm)'];

  // Weather getters
  Map<String, dynamic> get weatherData => currentPrediction['weather'];
  double? get temperature => currentPrediction['weather']['temperature'];
  int? get humidity => currentPrediction['weather']['humidity'];
  double? get rainfall => currentPrediction['weather']['rainfall'];

  // AI Recommendations
  List<String> get predictedCrop {
    final recommendations = currentPrediction['recommendations'];
    if (recommendations != null &&
        recommendations is Map &&
        recommendations.isNotEmpty) {
      // Convert all keys (crop names) into a list
      return recommendations.keys.toList().cast<String>();
    }
    return []; // Return empty list if no recommendations
  }

  // Method to update current prediction result
  void updateCurrentPrediction(Map<String, dynamic> newResult) {
    currentPrediction = newResult;
    if (!predictionResults.any(
      (prediction) =>
          prediction['location']['latitude'] ==
              newResult['location']['latitude'] &&
          prediction['location']['longitude'] ==
              newResult['location']['longitude'],
    )) {
      predictionResults.add(newResult);
    }
    notifyListeners();
  }

  // Method to parse prediction result from JSON string
  void parsePredictionResult(String jsonString) {
    try {
      final parsedResult = json.decode(jsonString);
      if (parsedResult is List) {
        predictionResults = List<Map<String, dynamic>>.from(parsedResult);
        if (predictionResults.isNotEmpty) {
          currentPrediction = predictionResults.last;
        }
      } else {
        updateCurrentPrediction(parsedResult);
      }
      notifyListeners();
    } catch (e) {
      print('Error parsing prediction result: $e');
    }
  }

  // Method to check if prediction is available
  bool get isPredictionAvailable =>
      currentPrediction['ai_recommendations']['predicted_crop'] != null;

  // Method to clear all predictions
  void clearPredictions() {
    predictionResults.clear();
    currentPrediction = {
      "location": {"latitude": null, "longitude": null, "address": "N/A"},
      "soil_properties": {},
      "weather": {},
      "ai_recommendations": {"predicted_crop": null},
    };
    notifyListeners();
  }

  // Method to fetch predictions based on latitude and longitude
  Future<void> fetchPredictions(double latitude, double longitude) async {
    try {
      final payload = {"latitude": latitude, "longitude": longitude};

      final result = await _cropPredictionService.getpredictedCrops(payload);

      if (result != null) {
        updateCurrentPrediction(result);
      }
    } catch (e) {
      debugPrint('Error fetching predictions: $e');
    }
  }
}
