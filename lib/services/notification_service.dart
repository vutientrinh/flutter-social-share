// import 'package:dio/dio.dart';
//
// import 'api_client.dart';
//
// class NotificationService{
//   final Dio _dio = ApiClient.dio;
//   Future<Response> getAllNotification({int page = 1, int size = 10}) async {
//     try {
//       return await _dio.get('/notifications', data: {
//         'page':page,
//         'size':size
//       });
//     } catch (e) {
//       throw Exception('Failed to fetch posts: $e');
//     }
//   }
// }
