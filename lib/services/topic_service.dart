import 'package:dio/dio.dart';
import 'api_client.dart';

class TopicService {
  final Dio _dio = ApiClient.dio;

  Future<Response> createPost(String name, String color) async {
    try {
      final response = await _dio.post(
        '/topic',
        data: {
          'name': name,
          'color': color,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}
