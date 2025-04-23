import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';

class ProductLikedService {
  final Dio _dio;

  ProductLikedService(this._dio);

  // Like a product
  Future<bool> likeProduct(String productId) async {
    try {
      final response = await _dio.post(
        '/api/products/like',
        data: {'productId': productId},
      );

      if (response.statusCode == 200) {
        return response.data['data']; // UUID as String
      } else {
        throw Exception('Failed to like product');
      }
    } catch (e) {
      throw Exception('Error liking product: $e');
    }
  }

  // Unlike a product
  Future<bool> unlikeProduct(String productId) async {
    try {
      final response = await _dio.post(
        '/api/products/unlike',
        data: {'productId': productId},
      );

      if (response.statusCode == 200) {
        return response.data['data'] == true;
      } else {
        throw Exception('Failed to unlike product');
      }
    } catch (e) {
      throw Exception('Error unliking product: $e');
    }
  }

  // Get liked products with pagination
  Future<List<Product>> getLikedProducts({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/api/products/liked',
        queryParameters: {'page': page, 'size': size},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch liked products');
      }
    } catch (e) {
      throw Exception('Error fetching liked products: $e');
    }
  }
}
