import 'package:dio/dio.dart';

class CommentLikeService {
  final Dio _dio;

  CommentLikeService(this._dio);

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
      print('Error unlike comment: $e');
      throw Exception('Failed to unlike comment: $e');
    }
  }

  Future<Response> getLikedUsersAPI(String commentId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio.get('/comments/$commentId/liked-users',
          data: {"page": page, "size": size});
      return response;
    } catch (e) {
      print('Error get liked users: $e');
      throw Exception('Failed to get liked users: $e');
    }
  }
}
