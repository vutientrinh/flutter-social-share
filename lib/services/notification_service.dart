import 'package:dio/dio.dart';

class NotificationService {
  final Dio _dio;

  NotificationService(this._dio);

  Future<Response> getAllNotification({int page = 1, int size = 10}) async {
    try {
      return await _dio
          .get('/api/notifications', data: {'page': page, 'size': size});
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
}
