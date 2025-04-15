import 'package:dio/dio.dart';

import '../model/user.dart';
import 'api_client.dart';

class UserService {
  final Dio _dio;
  UserService(this._dio);

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio
          .get('/users/all'); // Adjust according to your backend endpoint
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

  Future<Response> follow(String userId) async {
    try {
      final response = await _dio.post('/users/$userId/follow');
      return response;
    } catch (e) {
      print('Error adding follow: $e');
      throw Exception('Failed to follow user: $e'); // Optional: rethrow to handle elsewhere
    }
  }
  Future<Response> unfollow(String userId) async {
    try {
      final response = await _dio.delete('/users/$userId/unfollow');
      return response;
    } catch (e) {
      print('Error adding follow: $e');
      throw Exception('Failed to follow user: $e'); // Optional: rethrow to handle elsewhere
    }
  }
  Future<Response> getFollowers(String userId, {int page = 1, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/users/$userId/followers',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return response;
    } catch (e) {
      print('Error fetching followers: $e');
      throw Exception('Failed to fetch followers: $e');
    }
  }
  Future<Response> getFollowings(String userId, {int page = 1, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/users/$userId/followings',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return response;
    } catch (e) {
      print('Error fetching followers: $e');
      throw Exception('Failed to fetch followers: $e');
    }
  }
  Future<User> getProfileById(String userId) async {
    try {
      final response = await _dio.get(
        '/users/profile/$userId',
      );
      final userResponse = response.data['data'];
      return User.fromJson(userResponse);
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Failed to fetch profile: $e');
    }
  }

}
