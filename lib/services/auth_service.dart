import 'package:dio/dio.dart';
import 'api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = ApiClient.dio;

  Future<void> saveLoginData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['token']);
    await prefs.setString('refreshToken', data['refreshToken']);
    await prefs.setString('userId', data['id']);
    await prefs.setString('username', data['username']);
    await prefs.setString('tokenType', data['type']); // Usually "Bearer"
  }

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('tokenType');
  }


  Future<Response?> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      print('Login successfull');
      print(response.data);
      return response;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<Response?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'username': name,
        'email': email,
        'password': password,
        'role': []
      });
      return response;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }
}
