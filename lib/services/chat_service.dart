import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/conversation.dart';

class ChatService {
  final Dio _dio;

  ChatService(this._dio);

  Future<Response> getFriends() async {
    final response = await _dio.get('/api/users/all');
    print(response.data);
    return response;
  }

  Future<List<Conversation>> getUnSeenMessage(String fromUserId) async {
    try {
      String url = '/api/conversation/unseenMessages';
      if (fromUserId.isNotEmpty) {
        url = '$url/$fromUserId';
      }

      final response = await _dio.get(url);
      print(response);
      List<Conversation> conversations = (response.data as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
      return conversations;
    } catch (e) {
      print('Error fetching unseen messages in service: $e');
      rethrow;
    }
  }

  Future<List<Conversation>> setReadMessages(
      List<Conversation> chatMessages) async {
    try {
      print("Before get information");
      final response = await _dio.put('/api/conversation/setReadMessages');
      print("Response in service ${response.data}");
      return response.data;
    } catch (e) {
      print('Error get Read message: $e');
      rethrow;
    }
  }
}
