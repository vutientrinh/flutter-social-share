import 'package:dio/dio.dart';

import 'api_client.dart';

class CommentLikeService {
  final Dio _dio = ApiClient.dio;

  Future<Response> likeAPI(String commentId) async {
    try {
      final response = await _dio.post(
        '/comments/$commentId/like',
      );
      return response;
    } catch (e) {
      print('Error like comment: $e');
      throw Exception('Failed to like comment: $e');
    }
  }
  Future<Response> unlikeAPI(String commentId) async {
    try {
      final response = await _dio.post(
        '/comments/$commentId/unlike',
      );
      return response;
    } catch (e) {
      print('Error like comment: $e');
      throw Exception('Failed to like comment: $e');
    }
  }
}
