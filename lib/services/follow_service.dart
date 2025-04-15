import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/user.dart';

class FollowService {
  final Dio _dio;

  FollowService(this._dio);

  Future<Response> follow(String userId) async {
    try {
      final response = await _dio.post('/users/$userId/follow');
      return response;
    } catch (e) {
      print('Error adding follow: $e');
      throw Exception('Failed to add follow: $e');
    }
  }

  Future<Response> unfollow(String userId) async {
    try {
      final response = await _dio.delete('/users/$userId/unfollow');
      return response;
    } catch (e) {
      print('Error delete follow: $e');
      throw Exception('Failed to delete follow: $e');
    }
  }

  Future<List<User>> getFollowers(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio
          .get('/users/$userId/followers', data: {"page": page, "size": size});
      final List<dynamic> userListJson = response.data['data']['data'];

      return userListJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error get followers: $e');
      throw Exception('Failed to get followers: $e');
    }
  }

  Future<List<User>> getFollowings(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio
          .get('/users/$userId/followings', data: {"page": page, "size": size});

      final List<dynamic> userListJson = response.data['data']['data'];

      return userListJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error get followings: $e');
      throw Exception('Failed to get followings: $e');
    }
  }
}
