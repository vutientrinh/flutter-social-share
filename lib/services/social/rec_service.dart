import 'package:dio/dio.dart';
import '../../model/ecommerce/order_detail_response.dart';
import '../../model/social/post.dart';

class RecService {
  final Dio _dio;

  RecService(this._dio);

  Future<List<Post>> getRecPost({
    int? page = 1,
    int? size = 10,

  }) async {
    try {
      // ✅ Build query parameters
      final queryParams = {
        'page': page,
        'size': size,
      };

      final response =
      await _dio.get('/api/rec/rec-posts', queryParameters: queryParams);

      // ✅ Extract the nested list
      final postListJson = response.data['data']['data'] as List;

      // ✅ Parse into Post objects
      return postListJson.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
  Future<List<Product>> getRecProduct({
    int? page = 1,
    int? size = 10,

  }) async {
    try {
      // ✅ Build query parameters
      final queryParams = {
        'page': page,
        'size': size,
      };

      final response =
      await _dio.get('/api/rec/rec-products', queryParameters: queryParams);

      // ✅ Extract the nested list
      if (response.statusCode == 200) {
        // Access 'data' field and cast it as a List of user objects
        List<Product> products = (response.data['data']
        as List) // Ensure 'data' is treated as a List
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
}
