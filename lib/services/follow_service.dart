import 'package:dio/dio.dart';

import 'api_client.dart';

class FollowService {
  final Dio _dio = ApiClient.dio;

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

  Future<Response> getFollowers(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio.delete('/users/$userId/followers',
          data: {"page": page, "size": size});
      return response;
    } catch (e) {
      print('Error get followers: $e');
      throw Exception('Failed to get followers: $e');
    }
  }

  Future<Response> getFollowings(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio.delete('/users/$userId/followings',
          data: {"page": page, "size": size});
      return response;
    } catch (e) {
      print('Error get followings: $e');
      throw Exception('Failed to get followings: $e');
    }
  }
}
