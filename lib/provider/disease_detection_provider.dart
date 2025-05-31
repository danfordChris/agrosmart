import 'dart:io';
import 'package:agrosmart/models/crop_diseases_model.dart';
import 'package:agrosmart/services/crop_diseases_service.dart';
import 'package:flutter/foundation.dart';

enum DetectionState { initial, imageCaptured, processing, resultReady, error }

class DiseaseDetectionProvider extends ChangeNotifier {
  final CropDetectionService _detectionService;

  DetectionState _state = DetectionState.initial;
  File? _imageFile;
  CropDisease? _result;
  String? _errorMessage;

  DiseaseDetectionProvider(this._detectionService);

  DetectionState get state => _state;
  File? get imageFile => _imageFile;
  CropDisease? get result => _result;
  String? get errorMessage => _errorMessage;

  void captureImage(File imageFile) {
    _imageFile = imageFile;
    _state = DetectionState.imageCaptured;
    notifyListeners();
  }

  Future<void> processImage(File imageFile) async {
    try {
      _imageFile = imageFile;
      _state = DetectionState.processing;
      notifyListeners();

      _result = await _detectionService.detectDisease(imageFile);

      _state = DetectionState.resultReady;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to process image: ${e.toString()}';
      _state = DetectionState.error;
      notifyListeners();
    }
  }

  void reset() {
    _state = DetectionState.initial;
    _imageFile = null;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}
