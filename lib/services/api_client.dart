import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_social_share/providers/user_provider.dart';
import 'package:flutter_social_share/screens/authentication/login_screen.dart';
import 'package:flutter_social_share/main.dart'; // for navigatorKey
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(
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
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          // Clear user and redirect to login
          ref.read(userProvider.notifier).state = null;

          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
          );
        }

        return handler.next(e);
      },
    ),
  );

  return dio;
});

