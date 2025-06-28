import 'package:agrosmart/models/user_info_model.dart';

class SessionManager {
  SessionManager._();
  static final SessionManager _instance = SessionManager._();
  static SessionManager get instance => _instance;

  UserInfoModel? _userInfoModel;
  String? token;

  UserInfoModel get user {
    if (_userInfoModel == null) throw Exception("User is NULL");
    return _userInfoModel!;
  }

  void setUserInfo(UserInfoModel userinfo) {
    _userInfoModel = userinfo;
  }

  void clearSession() {
    _userInfoModel = null;
    token = null;
  }
}
