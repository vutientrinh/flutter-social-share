import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/social/notification.dart';

class NotificationService {
  final Dio _dio;

  NotificationService(this._dio);

  Future<List<AppNotification>> getAllNotification() async {
    try {
      final response = await _dio.get('/api/notifications');
      final notificationListJson = response.data['data'] as List;
      return notificationListJson
          .map((json) => AppNotification.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notification: $e');
    }
  }

  Future<void> readNotification(String id) async{
    try {
      final response = await _dio.post('/api/notifications/$id/read');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch notification: $e');
    }
  }
  Future<void> readAllNotification() async{
    try {
      final response = await _dio.post('/api/notifications/read-all');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch notification: $e');
    }
  }
}
