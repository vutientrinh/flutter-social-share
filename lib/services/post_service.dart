import 'dart:io';

import 'package:dio/dio.dart';
import '../model/post.dart';
import '../model/post_request.dart';
import 'api_client.dart';

class PostService {
  final Dio _dio = ApiClient.dio;

  /// Get all posts (default first page)
  Future<List<Post>> getAllPosts() async {
    try {
      final response = await _dio.get('/posts');

      // ✅ Get the nested list inside: response.data["data"]["data"]
      final postListJson = response.data['data']['data'] as List;

      // ✅ Convert each JSON object into a Post model
      return postListJson.map((json) => Post.fromJson(json)).toList();
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

  Future<Response> createPost(PostRequest postRequest) async {
    try {
      // Prepare list of MultipartFile
      List<MultipartFile> imageFiles = [];
      if (postRequest.images != null && postRequest.images!.isNotEmpty) {
        for (File image in postRequest.images) {
          imageFiles.add(await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ));
        }
      }

      FormData formData = FormData.fromMap({
        'content': postRequest.content,
        'authorId': postRequest.authorId,
        'topicId': postRequest.topicId,
        'images': imageFiles, // important: must match backend param name
      });

      return await _dio.post('/posts',
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ));
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
