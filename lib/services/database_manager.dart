import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:agrosmart/models/user_info_model.dart';
import 'package:agrosmart/models/market_product_model.dart';

class DatabaseManager extends BaseDatabaseManager {
	DatabaseManager._(): super("agrosmart.db", 1, _tables);
	static final DatabaseManager _instance = DatabaseManager._();
	static DatabaseManager get instance => _instance;

	static List<BaseDatabaseModel> get _tables {
		return [
			UserInfoModel(),
			MarketProductModel()
		];
	}
}