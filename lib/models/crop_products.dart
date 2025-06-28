
// A model class for crop products
class CropProduct {
  final String id;
  final String name;
  final String description;
  final String idealTemperature;
  final String imageUrl;
  final String suitability;
  final double price;
  final String seller;
  final String location;
  final String date;

  CropProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.idealTemperature,
    required this.imageUrl,
    required this.suitability,
    required this.price,
    required this.seller,
    required this.location,
    required this.date,
  });
}

// A model class for crop recommendation data
class CropRecommendation {
  final String name;
  final String description;
  final String idealTemperature;
  final String imageUrl;
  final String suitability;

  CropRecommendation({
    required this.name,
    required this.description,
    required this.idealTemperature,
    required this.imageUrl,
    required this.suitability,
  });
}
