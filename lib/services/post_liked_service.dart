import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/follow_response.dart';
import 'package:flutter_social_share/model/user.dart';

class PostLikedService {
  final Dio _dio;

  PostLikedService(this._dio);

  Future<Response> like(String postId) async {
    try {
      final response = await _dio.post('/posts/$postId/like');
      return response;
    } catch (e) {
      print('Error like: $e');
      throw Exception('Failed to like post: $e');
    }
  }
  Future<Response> unlike(String postId) async {
    try {
      final response = await _dio.delete('/posts/$postId/unlike');
      return response;
    } catch (e) {
      print('Error unlike: $e');
      throw Exception('Failed to unlike post: $e');
    }
  }
  Future<Response> getLikedUsers(String postId) async {
    try {
      final response = await _dio.get('/posts/$postId/liked-users');
      return response;
    } catch (e) {
      print('Error get liked users: $e');
      throw Exception('Failed to liked users: $e');
    }
  }
}
