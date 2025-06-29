import 'package:agrosmart/repositories/base_repository.dart';
import 'package:agrosmart/models/market_product_model.dart';

/// * ---------- Auto Generated Code ---------- * ///

class MarketProductRepository extends BaseRepository<MarketProductModel> {
	MarketProductRepository._(): super(MarketProductModel(), (map) => MarketProductModel.fromDatabase(map));
	static final MarketProductRepository _instance = MarketProductRepository._();
	static MarketProductRepository get instance => _instance;

}