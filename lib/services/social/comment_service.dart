import 'package:dio/dio.dart';
import '../../model/social/comment.dart';

class CommentService {
  final Dio _dio;

  CommentService(this._dio);

  Future<List<Comment>> getCommentsAPI(String postId) async {
    try {
      final response = await _dio.get(
        '/api/comments/$postId',
      );
      final List<dynamic> listCommentJson = response.data['data']['data'];
      return listCommentJson.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get comment by postId: $e');
    }
  }

  Future<Map<String, dynamic>> createComment(String postId, String content) async {
    try {
      final response = await _dio.post('/api/comments/create',
          data: {'postId': postId, 'content': content});
      return response.data;
    } catch (e) {
      throw Exception('Failed to get comment by postId: $e');
    }
  }
  Future<Map<String, dynamic>> updateComment(String commentId,String content) async {
    try {
      final response = await _dio.put('/api/comments/$commentId',data: {'content': content});
      return response.data;
    } catch (e) {
      throw Exception('Failed to update comment by postId: $e');
    }
  }
  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    try {
      final response = await _dio.delete('/api/comments/$commentId',
          data: {'uuid': commentId});
      return response.data;
    } catch (e) {
      throw Exception('Failed to get comment by postId: $e');
    }
  }

  Future<Map<String, dynamic>> likeComment(String commentId) async {
    try {
      final response = await _dio.post('/api/comments/$commentId/like');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get comment by postId: $e');
    }
  }
  Future<Map<String, dynamic>> unlikeComment(String commentId) async {
    try {
      final response = await _dio.post('/api/comments/$commentId/unlike');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get comment by postId: $e');
    }
  }
}
