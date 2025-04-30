import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/social/follow_response.dart';
import 'package:flutter_social_share/model/user.dart';

class FollowService {
  final Dio _dio;

  FollowService(this._dio);

  Future<Response> follow(String userId) async {
    try {
      final response = await _dio.post('/api/users/$userId/follow');
      return response;
    } catch (e) {
      throw Exception('Failed to add follow: $e');
    }
  }

  Future<Response> unfollow(String userId) async {
    try {
      final response = await _dio.delete('/api/users/$userId/unfollow');
      return response;
    } catch (e) {
      throw Exception('Failed to delete follow: $e');
    }
  }

  Future<List<FollowUserResponse>> getFollowers(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio
          .get('/api/users/$userId/followers', data: {"page": page, "size": size});
      final List<dynamic> followersListJson = response.data['data']['data'];

      return followersListJson.map((json) => FollowUserResponse.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get followers: $e');
    }
  }

  Future<List<FollowUserResponse>> getFollowings(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio
          .get('/api/users/$userId/followings', data: {"page": page, "size": size});

      final List<dynamic> followingsListJson = response.data['data']['data'];

      return followingsListJson.map((json) => FollowUserResponse.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get followings: $e');
    }
  }
}
