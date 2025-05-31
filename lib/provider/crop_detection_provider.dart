import 'dart:io';

import 'package:agrosmart/models/crop_diseases_model.dart';
import 'package:agrosmart/services/crop_diseases_service.dart';
import 'package:flutter/material.dart';

class CropDetectionProvider with ChangeNotifier {
  final CropDetectionService _detectionService;

  File? _imageFile;
  bool _isLoading = false;
  CropDisease? _disease;
  String? _error;

  CropDetectionProvider(this._detectionService) {
    print('CropDetectionProvider initialized');
  }

  File? get imageFile => _imageFile;
  bool get isLoading => _isLoading;
  CropDisease? get disease => _disease;
  String? get error => _error;

  Future<void> takePicture(File imageFile) async {
    print('takePicture called with file: ${imageFile.path}');
    _imageFile = imageFile;
    _disease = null;
    _error = null;
    notifyListeners();
    print('Image file set and listeners notified');
  }

  Future<void> analyzeImage() async {
    if (_imageFile == null) {
      print('analyzeImage called but no image file available');
      return;
    }

    try {
      print('Starting image analysis...');
      _isLoading = true;
      notifyListeners();

      _disease = await _detectionService.detectDisease(_imageFile!);
      print('Analysis completed successfully. Disease: ${_disease?.name}');
    } catch (e) {
      print('Error during analysis: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      print('Analysis finished. Loading state: $_isLoading');
    }
  }

  void reset() {
    print('Resetting provider state');
    _imageFile = null;
    _isLoading = false;
    _disease = null;
    _error = null;
    notifyListeners();
    print('Provider state reset complete');
  }
}
