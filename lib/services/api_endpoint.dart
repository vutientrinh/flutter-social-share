class ApiEndpoints {
  static const String baseUrl = '/api';  // Thay đổi nếu cần

}
class WebSocketUrl{
  static const String webSocketUrl = "/ws";
}
class Auth{
  static const String login = '${ApiEndpoints.baseUrl}/auth/login';
  static const String register = '${ApiEndpoints.baseUrl}/auth/register';
  static const String logout = '${ApiEndpoints.baseUrl}/auth/signout';
  static const String refreshToken = '${ApiEndpoints.baseUrl}/auth/refresh-token';
  static const String introspect = '${ApiEndpoints.baseUrl}/auth/introspect';
}
class User{
  static const String getByToken = '${ApiEndpoints.baseUrl}/users/profile';
  static const String getById = '${ApiEndpoints.baseUrl}/users/profile/{id}'; // {id} là placeholder cho userId
  static const String getByUserName = '${ApiEndpoints.baseUrl}/users/profile/accounts';
}
class Post{
  static const String getAllPosts = '${ApiEndpoints.baseUrl}/posts';
}
