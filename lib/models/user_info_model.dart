import 'package:agrosmart/starter_models/user_info_model.g.dart';

/// * ---------- Auto Generated Code ---------- * ///

class UserInfoModel extends UserInfoModelGen {
  UserInfoModel({
    int? id,
    String? username,
    String? email,
    String? first_name,
    String? last_name,
    String? phone_number,
    String? id_number,
    String? role,
    String? token,
    String? password,
    String? password2,
  }) : super(
         id,
         username,
         email,
         first_name,
         last_name,
         phone_number,
         id_number,
         role,
         token,
         password,
         password2,
       );

  factory UserInfoModel.fromDatabase(Map<String, dynamic> map) {
    return UserInfoModelGen.fromDatabase(map);
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> map) {
    return UserInfoModelGen.fromJson(map);
  }

  Map<String, dynamic> toJsonData() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "password2": password2,
      "first_name": first_name,
      "last_name": last_name,
      "phone_number": phone_number,
    };
  }

  Map<String, dynamic> toLoginData() {
    return {"username": username, "password": password};
  }
}
