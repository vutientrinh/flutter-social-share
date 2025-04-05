import 'package:dio/dio.dart';

import 'auth_service.dart';

class ChatService {
  final Dio _dio = Dio(); // Initialize Dio
  late String jwt; // use 'late' to assign it later

  Future<Response> getFriends() async {
    final response = await _dio.get('/conservation/friends');
    print(response.data);
    return response;
  }

  ChatService() {
    _initializeJwt();
  }

  void _initializeJwt() async {
    final data = await AuthService.getSavedData();
    jwt = data['token'];
  }

  Future<Response> getUnSeenMessage(String fromUserId) async {
    try {
      String url = '/conservation/unseenMessages';
      if (fromUserId.isNotEmpty) {
        url = '$url/$fromUserId';
      }
      final response = await _dio.put(url);
      print(response.data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> setReadMessages(
      List<Map<String, dynamic>> chatMessages) async {
    try {
      final response = await _dio.put(
        '/conversation/setReadMessages',
        data: chatMessages, // ← This is a List
      );
      print(response.data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
