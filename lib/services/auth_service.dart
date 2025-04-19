import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<void> saveLoginData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['token']);
    await prefs.setString('refreshToken', data['refreshToken']);
    await prefs.setString('userId', data['id']);
    await prefs.setString('username', data['username']);
    await prefs.setString('tokenType', data['type']); // Usually "Bearer"
  }

  Future<Map<String, dynamic>> getSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('token'),
      'refreshToken': prefs.getString('refreshToken'),
      'userId': prefs.getString('userId'),
      'username': prefs.getString('username'),
      'tokenType': prefs.getString('tokenType'),
    };
  }

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('tokenType');
  }

  Future<bool> introspect() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return false; // No token found, so it's invalid
      }

      // Call the introspect endpoint to verify the token validity
      final response = await _dio.post('/api/auth/introspect', data: {
        'token': token,
      });

      // If the token is valid, return true, otherwise false
      return response.data['valid'] == true;
    } catch (e) {
      print('Introspect Error: $e');
      return false;
    }
  }

  Future<Response?> login(String username, String password) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
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
      final response = await _dio.post('/api/auth/register', data: {
        'username': name,
        'email': email,
        'role': ["ROLE_USER"],
        'password': password
      });
      return response;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }
  Future<Response?> logout() async {
    try {
      final response = await _dio.post('/api/auth/signout');
      return response;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }
}
