import 'package:dio/dio.dart';
import 'api_client.dart';

class PostService {
  // Get all posts
  final Dio _dio = ApiClient.dio;
  Future<Response> getAllPosts() async {
    try {
      final response = await _dio.get('/posts');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  // Get posts per page
  Future<Response> getPostsPerPage(int page) async {
    try {
      final response = await _dio.get('/posts?page=$page');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch posts on page $page: $e');
    }
  }

  // Get comments by post ID
  Future<Response> getCommentsByPostId(String postId) async {
    try {
      final response = await _dio.get('/comments/$postId');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch comments for post $postId: $e');
    }
  }
}
