import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/social/post_update_request.dart';
import '../../model/social/post.dart';
import '../../model/social/post_request.dart';

class PostService {
  final Dio _dio;

  PostService(this._dio);

  Future<List<Post>> getAllPosts({
    int? page = 1,
    int? size = 10,
    int? type,
    String? topicName,
    String? authorId,
    String? keyword,
  }) async {
    try {
      // ✅ Build query parameters
      final queryParams = {
        'page': page,
        'size': size,
        if (type != null) 'type': type,
        if (topicName != null && topicName.isNotEmpty) 'topicName': topicName,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (authorId != null && authorId.isNotEmpty) 'authorId': authorId,
      };

      final response =
          await _dio.get('/api/posts', queryParameters: queryParams);

      // ✅ Extract the nested list
      final postListJson = response.data['data']['data'] as List;

      // ✅ Parse into Post objects
      return postListJson.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  /// Get a single post by UUID
  Future<Post> getPostById(String uuid) async {
    try {
      final response = await _dio.get('/api/posts/$uuid');
      final post = response.data['data'];


      // ✅ Parse into Post objects
      return Post.fromJson(post);
    } catch (e) {
      throw Exception('Failed to fetch post $uuid: $e');
    }
  }

  Future<Post> createPost(PostRequest postRequest) async {
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

      final response = await _dio.post(
        '/api/posts',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return Post.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  /// Update a post by UUID
  Future<Response> updatePost(
      String uuid, PostUpdateRequest postUpdateRequest) async {
    List<MultipartFile> imageFiles = [];
    if (postUpdateRequest.images != null &&
        postUpdateRequest.images!.isNotEmpty) {
      for (File image in postUpdateRequest.images) {
        imageFiles.add(await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ));
      }
    }

    FormData formData = FormData.fromMap({
      'content': postUpdateRequest.content,
      'topicId': postUpdateRequest.topicId,
      'images': imageFiles,
      'status': postUpdateRequest.status,
      'type': postUpdateRequest.type
    });

    try {
      return await _dio.put(
        '/api/posts/$uuid',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } catch (e) {
      throw Exception('Failed to update post $uuid: $e');
    }
  }

  /// Delete a post by UUID
  Future<Response> deletePost(String uuid) async {
    try {
      return await _dio.delete('/api/posts/$uuid');
    } catch (e) {
      throw Exception('Failed to delete post $uuid: $e');
    }
  }

  Future<Response> savePost(String authorId, String postId) async {
    final request = {'authorId': authorId, 'postId': postId};
    try {
      return await _dio.post('/api/posts/save', data: request);
    } catch (e) {
      throw Exception('Failed to save post : $e');
    }
  }

  Future<Response> unSavePost(String authorId, String postId) async {
    final request = {'authorId': authorId, 'postId': postId};
    try {
      return await _dio.delete('/api/posts/unsaved', data: request);
    } catch (e) {
      throw Exception('Failed to unSave post : $e');
    }
  }

  Future<List<Post>> getSavedPosts() async {
    try {
      final response = await _dio.get('/api/posts/saved');
      final postListJson = response.data['data'] as List;

      return postListJson.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to unSave post : $e');
    }
  }

  Future<List<String>> getPhotos(String userId) async {
    try {
      final response = await _dio.get('/api/posts/$userId/images');

      if (response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        return List<String>.from(response.data['data']);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      throw Exception('Failed to get photos: $e');
    }
  }

  Future<List<Post>> getRecPost({
    int? page = 1,
    int? size = 10,
  }) async {
    try {
      // ✅ Build query parameters
      final queryParams = {
        'page': page,
        'size': size,
      };

      final response =
          await _dio.get('/api/rec/rec-posts', queryParameters: queryParams);

      // ✅ Extract the nested list
      final postListJson = response.data['data']['data'] as List;

      // ✅ Parse into Post objects
      return postListJson.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
}
