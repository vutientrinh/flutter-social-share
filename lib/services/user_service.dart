import 'package:dio/dio.dart';

import '../model/user.dart';
import 'api_client.dart';

class UserService {
  final Dio _dio = ApiClient.dio;
  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get('/users/all');  // Adjust according to your backend endpoint
      if (response.statusCode == 200) {
        // Access 'data' field and cast it as a List of user objects
        List<User> users = (response.data['data'] as List)  // Ensure 'data' is treated as a List
            .map((userJson) => User.fromJson(userJson))
            .toList();
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

}
