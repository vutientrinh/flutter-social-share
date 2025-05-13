import 'package:dio/dio.dart';

import '../../model/social/topic.dart';

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

  Future<List<Topic>> getAllTopics() async {
    try {
      final response = await _dio.get('/api/topic/all');

      // Correctly access the list of topics
      final List<dynamic> listTopic = response.data['data'];
      print("List topic in service : $listTopic");
      return listTopic.map((json) => Topic.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get all topic: $e');
    }
  }
}
