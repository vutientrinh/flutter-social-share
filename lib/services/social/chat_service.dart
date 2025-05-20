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

  Future<List<Conversation>> getMessageBefore({
    String? messageId,
    String? convId,
    int page = 1,
    int size = 100,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
        if (messageId != null && messageId.isNotEmpty) 'messageId': messageId,
        if (convId != null && convId.isNotEmpty) 'convId': convId,
      };

      final response = await _dio.get(
        '/api/conversation/getMessagesBefore',
        queryParameters: queryParams,
      );

      final List<dynamic> dataList = response.data['data'] ?? [];

      return dataList.map((json) => Conversation.fromJson(json)).toList();
    } catch (e) {
      print('Error get Read message: $e');
      rethrow;
    }
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
