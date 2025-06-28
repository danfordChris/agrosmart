import 'package:agrosmart/models/user_info_model.dart';
import 'package:ipf_flutter_starter_pack/bases.dart';

/// * ---------- Auto Generated Code ---------- * ///

class UserInfoModelGen extends BaseDatabaseModel {
	int? _id;
	String? _username;
	String? _email;
	String? _first_name;
	String? _last_name;
	String? _phone_number;
	String? _id_number;
	String? _role;
	String? _token;
	String? _password;
	String? _password2;
	
	UserInfoModelGen(this._id, this._username, this._email, this._first_name, this._last_name, this._phone_number, this._id_number, this._role, this._token, this._password, this._password2, );

	int? get id => _id;
	String? get username => _username;
	String? get email => _email;
	String? get first_name => _first_name;
	String? get last_name => _last_name;
	String? get phone_number => _phone_number;
	String? get id_number => _id_number;
	String? get role => _role;
	String? get token => _token;
	String? get password => _password;
	String? get password2 => _password2;
	
	set id(int? id) => this._id = id;
	set username(String? username) => this._username = username;
	set email(String? email) => this._email = email;
	set first_name(String? first_name) => this._first_name = first_name;
	set last_name(String? last_name) => this._last_name = last_name;
	set phone_number(String? phone_number) => this._phone_number = phone_number;
	set id_number(String? id_number) => this._id_number = id_number;
	set role(String? role) => this._role = role;
	set token(String? token) => this._token = token;
	set password(String? password) => this._password = password;
	set password2(String? password2) => this._password2 = password2;
	

	static UserInfoModel fromJson(Map<String, dynamic> map) {
		return UserInfoModel(id: BaseModel.castToInt(map['id']), username: map['username'], email: map['email'], first_name: map['first_name'], last_name: map['last_name'], phone_number: map['phone_number'], id_number: map['id_number'], role: map['role'], token: map['token'], password: map['password'], password2: map['password2'], );
	}

	static UserInfoModel fromDatabase(Map<String, dynamic> map) {
		return UserInfoModel(id: BaseModel.castToInt(map['id']), username: map['username'], email: map['email'], first_name: map['first__name'], last_name: map['last__name'], phone_number: map['phone__number'], id_number: map['id__number'], role: map['role'], token: map['token'], password: map['password'], password2: map['password_2'], );
	}

	@override
	String get tableName => "user_info";

	@override
	Map<String, dynamic> get toMap {
		return { "id": id, "username": username, "email": email, "first__name": first_name, "last__name": last_name, "phone__number": phone_number, "id__number": id_number, "role": role, "token": token, "password": password, "password_2": password2, };
	}

	Map<String, dynamic> get toJson {
		return { "id": id, "username": username, "email": email, "first_name": first_name, "last_name": last_name, "phone_number": phone_number, "id_number": id_number, "role": role, "token": token, "password": password, "password2": password2, };
	}

	@override
	Map<String, String> get toSchema {
		return { "id": "INTEGER PRIMARY KEY", "username": "TEXT", "email": "TEXT", "first__name": "TEXT", "last__name": "TEXT", "phone__number": "TEXT", "id__number": "TEXT", "role": "TEXT", "token": "TEXT", "password": "TEXT", "password_2": "TEXT", };
	}

	UserInfoModel merge(UserInfoModel model) {
		return UserInfoModel(
			id: model.id ?? this._id,
			username: model.username ?? this._username,
			email: model.email ?? this._email,
			first_name: model.first_name ?? this._first_name,
			last_name: model.last_name ?? this._last_name,
			phone_number: model.phone_number ?? this._phone_number,
			id_number: model.id_number ?? this._id_number,
			role: model.role ?? this._role,
			token: model.token ?? this._token,
			password: model.password ?? this._password,
			password2: model.password2 ?? this._password2
		);
	}

	@override
	Map<String, Map<String, String>>? get dataRelation => null;

}