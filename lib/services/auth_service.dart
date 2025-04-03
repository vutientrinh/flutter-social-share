import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "https://your-backend-url.com/api"; // Change this
  final storage = const FlutterSecureStorage(); // Secure storage for tokens

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: "token", value: data["token"]);
        await storage.write(key: "refreshToken", value: data["refreshToken"]);
        await storage.write(key: "username", value: data["username"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await storage.deleteAll(); // Remove all stored credentials
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<bool> isAuthenticated() async {
    String? token = await getToken();
    return token != null;
  }
}
