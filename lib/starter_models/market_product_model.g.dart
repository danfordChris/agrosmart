import 'package:agrosmart/models/market_product_model.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';

/// * ---------- Auto Generated Code ---------- * ///

class MarketProductModelGen extends BaseDatabaseModel {
	int? _id;
	String? _name;
	String? _description;
	String? _price;
	String? _category;
	int? _quantity;
	String? _location;
	String? _contact_info;
	String? _idealTemperature;
	String? _suitability;
	String? _image;
	String? _imageUrl;
	String? _seller;
	String? _phone;
	String? _date;
	String? _created_at;
	String? _updated_at;
	
	MarketProductModelGen(this._id, this._name, this._description, this._price, this._category, this._quantity, this._location, this._contact_info, this._idealTemperature, this._suitability, this._image, this._imageUrl, this._seller, this._phone, this._date, this._created_at, this._updated_at, );

	int? get id => _id;
	String? get name => _name;
	String? get description => _description;
	String? get price => _price;
	String? get category => _category;
	int? get quantity => _quantity;
	String? get location => _location;
	String? get contact_info => _contact_info;
	String? get idealTemperature => _idealTemperature;
	String? get suitability => _suitability;
	String? get image => _image;
	String? get imageUrl => _imageUrl;
	String? get seller => _seller;
	String? get phone => _phone;
	String? get date => _date;
	String? get created_at => _created_at;
	String? get updated_at => _updated_at;
	
	set id(int? id) => this._id = id;
	set name(String? name) => this._name = name;
	set description(String? description) => this._description = description;
	set price(String? price) => this._price = price;
	set category(String? category) => this._category = category;
	set quantity(int? quantity) => this._quantity = quantity;
	set location(String? location) => this._location = location;
	set contact_info(String? contact_info) => this._contact_info = contact_info;
	set idealTemperature(String? idealTemperature) => this._idealTemperature = idealTemperature;
	set suitability(String? suitability) => this._suitability = suitability;
	set image(String? image) => this._image = image;
	set imageUrl(String? imageUrl) => this._imageUrl = imageUrl;
	set seller(String? seller) => this._seller = seller;
	set phone(String? phone) => this._phone = phone;
	set date(String? date) => this._date = date;
	set created_at(String? created_at) => this._created_at = created_at;
	set updated_at(String? updated_at) => this._updated_at = updated_at;
	

	static MarketProductModel fromJson(Map<String, dynamic> map) {
		return MarketProductModel(id: BaseModel.castToInt(map['id']), name: map['name'], description: map['description'], price: map['price'], category: map['category'], quantity: BaseModel.castToInt(map['quantity']), location: map['location'], contact_info: map['contact_info'], idealTemperature: map['idealTemperature'], suitability: map['suitability'], image: map['image'], imageUrl: map['imageUrl'], seller: map['seller'], phone: map['phone'], date: map['date'], created_at: map['created_at'], updated_at: map['updated_at'], );
	}

	static MarketProductModel fromDatabase(Map<String, dynamic> map) {
		return MarketProductModel(id: BaseModel.castToInt(map['id']), name: map['name'], description: map['description'], price: map['price'], category: map['category'], quantity: BaseModel.castToInt(map['quantity']), location: map['location'], contact_info: map['contact__info'], idealTemperature: map['ideal_temperature'], suitability: map['suitability'], image: map['image'], imageUrl: map['image_url'], seller: map['seller'], phone: map['phone'], date: map['date'], created_at: map['created__at'], updated_at: map['updated__at'], );
	}

	@override
	String get tableName => "market_product";

	@override
	Map<String, dynamic> get toMap {
		return { "id": id, "name": name, "description": description, "price": price, "category": category, "quantity": quantity, "location": location, "contact__info": contact_info, "ideal_temperature": idealTemperature, "suitability": suitability, "image": image, "image_url": imageUrl, "seller": seller, "phone": phone, "date": date, "created__at": created_at, "updated__at": updated_at, };
	}

	Map<String, dynamic> get toJson {
		return { "id": id, "name": name, "description": description, "price": price, "category": category, "quantity": quantity, "location": location, "contact_info": contact_info, "idealTemperature": idealTemperature, "suitability": suitability, "image": image, "imageUrl": imageUrl, "seller": seller, "phone": phone, "date": date, "created_at": created_at, "updated_at": updated_at, };
	}

	@override
	Map<String, String> get toSchema {
		return { "id": "INTEGER PRIMARY KEY", "name": "TEXT", "description": "TEXT", "price": "TEXT", "category": "TEXT", "quantity": "INTEGER", "location": "TEXT", "contact__info": "TEXT", "ideal_temperature": "TEXT", "suitability": "TEXT", "image": "TEXT", "image_url": "TEXT", "seller": "TEXT", "phone": "TEXT", "date": "TEXT", "created__at": "TEXT", "updated__at": "TEXT", };
	}

	MarketProductModel merge(MarketProductModel model) {
		return MarketProductModel(
			id: model.id ?? this._id,
			name: model.name ?? this._name,
			description: model.description ?? this._description,
			price: model.price ?? this._price,
			category: model.category ?? this._category,
			quantity: model.quantity ?? this._quantity,
			location: model.location ?? this._location,
			contact_info: model.contact_info ?? this._contact_info,
			idealTemperature: model.idealTemperature ?? this._idealTemperature,
			suitability: model.suitability ?? this._suitability,
			image: model.image ?? this._image,
			imageUrl: model.imageUrl ?? this._imageUrl,
			seller: model.seller ?? this._seller,
			phone: model.phone ?? this._phone,
			date: model.date ?? this._date,
			created_at: model.created_at ?? this._created_at,
			updated_at: model.updated_at ?? this._updated_at
		);
	}

	@override
	Map<String, Map<String, String>>? get dataRelation => null;

}