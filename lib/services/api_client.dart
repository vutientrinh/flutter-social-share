import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_social_share/screens/authentication/login_screen.dart';
import 'package:flutter_social_share/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_token_provider.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://34.126.161.244.nip.io:8280/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
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
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          await ref.read(authTokenProvider.notifier).clearToken(); // logout
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
final shippingApiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['GHN_URL'] ??
        'https://dev-online-gateway.ghn.vn/shiip/public-api/v2',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final tokenGHN = dotenv.env['GHN_TOKEN']??'fa84809c-0f92-11f0-95d0-0a92b8726859';
    final locale = prefs.getString('defaultLocale') ?? 'en-US';

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Token'] = tokenGHN;
    options.headers['Accept-Language'] = locale;

    return handler.next(options);
  }, onResponse: (response, handler) {
    print("✅ [Response] ${response.statusCode} - ${response.data}");
    return handler.next(response);
  }, onError: (DioException e, handler) {
    print("❌ [Dio Error] ${e.response?.statusCode} - ${e.message}");
    return handler.next(e);
  }));

  return dio;
});
