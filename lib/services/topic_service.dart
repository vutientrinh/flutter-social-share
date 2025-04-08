import 'package:dio/dio.dart';
import 'package:http/http.dart';

import 'api_client.dart';

class TopicService{
  final Dio _dio = ApiClient.dio;

  Future<Response> createPost(String name, String color) async{
    final request =
    try {
      return await _dio.post('/topic');
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
}