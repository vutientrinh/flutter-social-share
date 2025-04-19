import 'package:dio/dio.dart';

class TopicService {
  final Dio _dio;

  TopicService(this._dio);

  Future<Response> createTopic(String name, String color) async {
    try {
      final response = await _dio.post(
        '/api/topic',
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

  Future<Response> getAllTopics({int page = 1, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/api/topic/all',
        data: {
          'page': page,
          'size': size,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get all topic: $e');
    }
  }
}
