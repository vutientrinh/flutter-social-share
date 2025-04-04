import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  static Dio get dio {
    _dio.interceptors.clear(); // Clear previous interceptors to avoid duplicates
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          final locale = prefs.getString('defaultLocale') ?? 'en-US';

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept-Language'] = locale;

          print("📡 [Request] ${options.method} ${options.uri}");
          print("🔹 Headers: ${options.headers}");
          print("🔹 Body: ${options.data}");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ [Response] ${response.statusCode} - ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ [Error] ${e.message}");
          print("🚨 Error Details: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );
    return _dio;
  }
}
