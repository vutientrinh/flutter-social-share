import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  Future<dynamic> getRequest(String endpoint) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url);
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw Exception("Bad request: ${response.body}");
      case 401:
        throw Exception("Unauthorized: ${response.body}");
      case 404:
        throw Exception("Not found: ${response.body}");
      case 500:
        throw Exception("Server error: ${response.body}");
      default:
        throw Exception("Unknown error: ${response.statusCode}");
    }
  }
}
