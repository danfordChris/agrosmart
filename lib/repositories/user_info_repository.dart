import 'package:agrosmart/repositories/base_repository.dart';
import 'package:agrosmart/models/user_info_model.dart';

/// * ---------- Auto Generated Code ---------- * ///

class UserInfoRepository extends BaseRepository<UserInfoModel> {
	UserInfoRepository._(): super(UserInfoModel(), (map) => UserInfoModel.fromDatabase(map));
	static final UserInfoRepository _instance = UserInfoRepository._();
	static UserInfoRepository get instance => _instance;

}