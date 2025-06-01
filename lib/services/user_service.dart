import 'package:dio/dio.dart';

import '../model/user.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio);

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio
          .get('/api/users/all'); // Adjust according to your backend endpoint
      if (response.statusCode == 200) {
        // Access 'data' field and cast it as a List of user objects
        List<User> users = (response.data['data']
                as List) // Ensure 'data' is treated as a List
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

  Future<List<User>> getSuggestedUsers() async {
    try {
      final response = await _dio.get(
          '/api/users/suggested'); // Adjust according to your backend endpoint
      if (response.statusCode == 200) {
        // Access 'data' field and cast it as a List of user objects
        List<User> users = (response.data['data']
                as List) // Ensure 'data' is treated as a List
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

  Future<User> getProfileById(String userId) async {
    try {
      final response = await _dio.get(
        '/api/users/profile/$userId',
      );
      final userResponse = response.data['data'];

      return User.fromJson(userResponse);
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<Response> updateProfile(String avatar, String cover, String firstName,
      String lastName, String bio, String websiteUrl) async {
    try {
      final response = await _dio.put('/api/users/profile', data: {
        "avatar": avatar,
        "cover": cover,
        "firstName": firstName,
        "lastName": lastName,
        "bio": bio,
        "websiteUrl": websiteUrl
      });

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        // Still return the response so you can inspect it
        return e.response!;
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
