import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.dio;

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
        'role':[]
      });
      return response;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }
}
