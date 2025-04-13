import 'package:dio/dio.dart';

import '../model/comment.dart';
import 'api_client.dart';

class CommentService{
  final Dio _dio = ApiClient.dio;

  Future<List<Comment>> getCommentsAPI(String postId) async {
    try {
      final response = await _dio.post(
        '/comments/$postId',
      );
      final List<dynamic> listCommentJson = response.data['data']['data'];
      return listCommentJson.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      print('Error like comment by postId: $e');
      throw Exception('Failed to get comment by postId: $e');
    }
  }
}