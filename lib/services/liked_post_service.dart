import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/follow_response.dart';
import 'package:flutter_social_share/model/user.dart';

class LikedPostService {
  final Dio _dio;

  LikedPostService(this._dio);

  Future<Response> like(String postId) async {
    try {
      final response = await _dio.post('/api/posts/$postId/like');
      return response;
    } catch (e) {
      print('Error like: $e');
      throw Exception('Failed to like post: $e');
    }
  }
  Future<Response> unlike(String postId) async {
    try {
      final response = await _dio.delete('/api/posts/$postId/unlike');
      return response;
    } catch (e) {
      print('Error unlike: $e');
      throw Exception('Failed to unlike post: $e');
    }
  }
  Future<Response> getLikedUsers(String postId) async {
    try {
      final response = await _dio.get('/api/posts/$postId/liked-users');
      return response;
    } catch (e) {
      print('Error get liked users: $e');
      throw Exception('Failed to liked users: $e');
    }
  }
}
