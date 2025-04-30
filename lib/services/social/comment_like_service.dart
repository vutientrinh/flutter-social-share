import 'package:dio/dio.dart';

class CommentLikeService {
  final Dio _dio;

  CommentLikeService(this._dio);

  Future<Response> likeAPI(String commentId) async {
    try {
      final response = await _dio.post(
        '/api/comments/$commentId/like',
      );
      return response;
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<Response> unlikeAPI(String commentId) async {
    try {
      final response = await _dio.post(
        '/api/comments/$commentId/unlike',
      );
      return response;
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }

  Future<Response> getLikedUsersAPI(String commentId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio.get('/api/comments/$commentId/liked-users',
          data: {"page": page, "size": size});
      return response;
    } catch (e) {
      throw Exception('Failed to get liked users: $e');
    }
  }
}
