import 'package:agrosmart/models/market_product_model.dart';
import 'package:agrosmart/models/user_info_model.dart';

class SessionManager {
  SessionManager._();
  static final SessionManager _instance = SessionManager._();
  static SessionManager get instance => _instance;

  UserInfoModel? _userInfoModel;
  String? token;

  List<MarketProductModel>? _marketProductList;

  UserInfoModel get user {
    if (_userInfoModel == null) throw Exception("User is NULL");
    return _userInfoModel!;
  }

  void setUserInfo(UserInfoModel userinfo) {
    _userInfoModel = userinfo;
  }

  List<MarketProductModel> get products {
    if (_marketProductList == null) throw Exception("products are NULL");
    return _marketProductList!;
  }

  void setMarketProducts(List<MarketProductModel> products) {
    _marketProductList = products;
  }

  void clearSession() {
    _userInfoModel = null;
    token = null;
  }
}
