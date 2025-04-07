import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/conversation.dart';

import 'api_client.dart';
import 'auth_service.dart';

class ChatService {
  final Dio _dio = ApiClient.dio;
  Future<Response> getFriends() async {
    final response = await _dio.get('/users/all');
    print(response.data);
    return response;
  }

  Future<List<Map<String, dynamic>>> getUnSeenMessage(String fromUserId) async {
    try {
      String url = '/conversation/unseenMessages';
      if (fromUserId.isNotEmpty) {
        url = '$url/$fromUserId';
      }

      final response = await _dio.put(url);
      final List<dynamic> data = response.data;

      // Ensure you return raw map data, not a Conversation object
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching unseen messages: $e');
      rethrow;
    }
  }

  Future<List<Conversation>> setReadMessages(
      List<Conversation> chatMessages) async {
    try {
      print("Before get information");
      final response = await _dio.put('/conversation/setReadMessages');

      print("Response in service ${response.data}");

      // if (response.data != null && response.data is List) {
      //   // Directly return the response data as a list of maps
      //   List<Map<String, dynamic>> responseData = List<Map<String, dynamic>>.from(response.data['data']);
      //   return responseData;
      return response.data;
    } catch (e) {
      print('Error get Read message: $e');
      rethrow;
    }
  }
}
