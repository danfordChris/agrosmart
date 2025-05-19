class CropDisease {
  final String name;
  final String description;
  final String treatmentSuggestion;
  final double confidence;

  CropDisease({
    required this.name,
    required this.description,
    required this.treatmentSuggestion,
    required this.confidence,
  });

  factory CropDisease.fromMap(Map<String, dynamic> data) {
    return CropDisease(
      name: data['name'],
      description: data['description'],
      treatmentSuggestion: data['treatmentSuggestion'],
      confidence: data['confidence'],
    );
  }
}

class CropDiseaseResult {
  final bool isHealthy;
  final List<CropDisease> diseases;
  final DateTime scannedAt;

  CropDiseaseResult({
    required this.isHealthy,
    required this.diseases,
    required this.scannedAt,
  });
}

// Sample data to use while waiting for AI model response
class MockData {
  static List<CropDisease> getSampleDiseases() {
    return [
      CropDisease(
        name: 'Late Blight',
        description: 'Fungal disease affecting tomatoes and potatoes. Causes dark lesions on leaves and stems that can spread rapidly.',
        treatmentSuggestion: 'Apply copper-based fungicide and ensure proper crop spacing for air circulation.',
        confidence: 0.89,
      ),
      CropDisease(
        name: 'Powdery Mildew',
        description: 'Fungal disease appearing as white powdery spots on leaves and stems.',
        treatmentSuggestion: 'Apply sulfur-based fungicide and avoid overhead watering.',
        confidence: 0.76,
      ),
      CropDisease(
        name: 'Aphid Infestation',
        description: 'Small insects that suck sap from plants, causing leaf curl and stunted growth.',
        treatmentSuggestion: 'Use insecticidal soap or neem oil, and introduce beneficial insects.',
        confidence: 0.68,
      ),
    ];
  }

  static CropDiseaseResult getRandomResult() {
    final diseases = getSampleDiseases();
    final bool isHealthy = DateTime.now().millisecond % 3 == 0;
    
    return CropDiseaseResult(
      isHealthy: isHealthy,
      diseases: isHealthy ? [] : [diseases[DateTime.now().second % diseases.length]],
      scannedAt: DateTime.now(),
    );
  }
}