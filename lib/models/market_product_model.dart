import 'package:agrosmart/starter_models/market_product_model.g.dart';

/// * ---------- Auto Generated Code ---------- * ///

class MarketProductModel extends MarketProductModelGen {
	MarketProductModel({
		int? id,
		String? name,
		String? description,
		String? price,
		String? category,
		int? quantity,
		String? location,
		String? contact_info,
		String? idealTemperature,
		String? suitability,
		String? image,
		String? imageUrl,
		String? seller,
		String? phone,
		String? date,
		String? created_at,
		String? updated_at
	}): super(id, name, description, price, category, quantity, location, contact_info, idealTemperature, suitability, image, imageUrl, seller, phone, date, created_at, updated_at);

	factory MarketProductModel.fromDatabase(Map<String, dynamic> map) {
		return MarketProductModelGen.fromDatabase(map);
	}

	factory MarketProductModel.fromJson(Map<String, dynamic> map) {
		return MarketProductModelGen.fromJson(map);
	}

}