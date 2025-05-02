import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/social/conversation.dart';
import 'package:flutter_social_share/model/social/friend_connection.dart';

class ChatService {
  final Dio _dio;

  ChatService(this._dio);

  Future<List<FriendConnection>> getFriends() async {
    final response = await _dio.get('/api/conversation/friends');
    return (response.data as List)
        .map((json) => FriendConnection.fromJson(json))
        .toList();
  }

  Future<List<Conversation>> getUnSeenMessage(String fromUserId) async {
    try {
      String url = '/api/conversation/unseenMessages';
      if (fromUserId.isNotEmpty) {
        url = '$url/$fromUserId';
      }

      final response = await _dio.get(url);
      List<Conversation> conversations = (response.data as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
      return conversations;
    } catch (e) {
      print('Error fetching unseen messages in service: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getUnSeenMessageCount() async {
    try {

      final response = await _dio.get('/api/conversation/unseenMessages');
      return response.data;
    } catch (e) {
      print('Error fetching  messages in service: $e');
      rethrow;
    }
  }


  Future<List<Conversation>> setReadMessages(
      List<Conversation> chatMessages) async {
    try {
      final response = await _dio.put('/api/conversation/setReadMessages');
      return response.data;
    } catch (e) {
      print('Error get Read message: $e');
      rethrow;
    }
  }
}
