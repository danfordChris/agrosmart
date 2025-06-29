import 'package:ipf_flutter_starter_pack/bases.dart';
import 'package:ipf_flutter_starter_pack/services.dart';

void main() {
  List<BaseModelGenerator> generator = [_UserInfo(), _MarketProduct()];
  CodeGenerator.of('agrosmart', generator).generate();
}

class _UserInfo extends BaseModelGenerator {
  _UserInfo()
    : super.database('user_info', {
        'id': int,
        'username': String,
        "email": String,
        "first_name": String,
        "last_name": String,
        "phone_number": String,
        "id_number": String,
        "role": String,
        "token": String,
        "password": String,
        "password2": String,
      });
}

class _MarketProduct extends BaseModelGenerator {
  _MarketProduct()
    : super.database('market_product', {
        'id': int,
        'name': String,
        "description": String,
        "price": String,
        "category": String,
        "quantity": int,
        "location": String,
        "contact_info": String,
        "idealTemperature": String,
        "suitability": String,
        "image": String,
        "imageUrl": String,
        "seller": String,
        "phone": String,
        "date": String,
        "created_at": String,
        "updated_at": String,
      });
}
