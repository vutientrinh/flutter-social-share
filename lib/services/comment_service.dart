import 'package:dio/dio.dart';
import '../model/comment.dart';

class CommentService {
  final Dio _dio;

  CommentService(this._dio);

  Future<List<Comment>> getCommentsAPI(String postId) async {
    try {
      final response = await _dio.get(
        '/comments/$postId',
      );
      final List<dynamic> listCommentJson = response.data['data']['data'];
      return listCommentJson.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      print('Error like comment by postId: $e');
      throw Exception('Failed to get comment by postId: $e');
    }
  }

  Future<Response> createComment(String postId, String content) async {
    try {
      final response = await _dio.post('/comments/create',
          data: {'postId': postId, 'content': content});
      return response.data;
    } catch (e) {
      print('Error comment by postId: $e');
      throw Exception('Failed to get comment by postId: $e');
    }
  }
}
