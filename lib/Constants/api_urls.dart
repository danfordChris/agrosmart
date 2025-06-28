class ApiUrls {
  ApiUrls._();
  static final baseUrl = 'https://ewe-relevant-fox.ngrok-free.app';
  static final String signUp = '$baseUrl/api/auth/register/';
  static final String updateProfile = '$baseUrl/api/auth/profile/update/';
  static final String login = '$baseUrl/api/auth/login/';
  static final String resetPassword =
      '$baseUrl/api/auth/password-reset/request/';
  static final String cropRecomend = '$baseUrl/api/recommend/';
}
