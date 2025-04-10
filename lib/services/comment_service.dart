import 'package:dio/dio.dart';

import 'api_client.dart';

class CommentService{
  final Dio _dio = ApiClient.dio;

  Future<Response> getCommentsAPI(String commentId) async {
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
}