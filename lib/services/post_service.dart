import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/newPostPayload.dart';
import 'api_client.dart';

class PostService {
  final Dio _dio = ApiClient.dio;

  /// Get all posts (default first page)
  Future<Response> getAllPosts() async {
    try {
      return await _dio.get('/posts');
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  /// Get paginated posts
  Future<Response> listPost(int page, {int size = 10}) async {
    try {
      return await _dio.get('/posts?page=$page&size=$size');
    } catch (e) {
      throw Exception('Failed to fetch posts on page $page: $e');
    }
  }

  /// Get a single post by UUID
  Future<Response> getPostById(String uuid) async {
    try {
      return await _dio.get('/posts/$uuid');
    } catch (e) {
      throw Exception('Failed to fetch post $uuid: $e');
    }
  }

  /// Create a new post
  Future<Response> createPost(
      String content, String images, String authorId, String topicId) async {
    try {
      return await _dio.post('/posts', data: {
        'content': content,
        'images': images,
        'authorId': authorId,
        'topicId': topicId
      });
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  /// Update a post by UUID
  Future<Response> updatePost(
      String uuid, Map<String, dynamic> postUpdateRequest) async {
    try {
      return await _dio.put('/posts/$uuid', data: postUpdateRequest);
    } catch (e) {
      throw Exception('Failed to update post $uuid: $e');
    }
  }

  /// Delete a post by UUID
  Future<Response> deletePost(String uuid) async {
    try {
      return await _dio.delete('/posts/$uuid');
    } catch (e) {
      throw Exception('Failed to delete post $uuid: $e');
    }
  }

  /// Optional: Get comments for a post
  Future<Response> getCommentsByPostId(String postId) async {
    try {
      return await _dio.get('/comments/$postId');
    } catch (e) {
      throw Exception('Failed to fetch comments for post $postId: $e');
    }
  }
}
