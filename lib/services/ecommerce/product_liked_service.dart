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
        return true;
      } else {
        return false;
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
        return true;
      } else {
        return false;
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
      final response = await _dio.get('/api/products/liked');

      if (response.statusCode == 200) {
        final data = response.data['data']; // Map with currentPage, totalPages, data
        final List<dynamic> productsJson = data['data']; // Here is the List<Product>

        List<Product> products = productsJson.map((item) => Product.fromJson(item)).toList();
        return products;
      } else {
        throw Exception('Failed to fetch liked products');
      }
    } catch (e) {
      throw Exception('Error fetching liked products: $e');
    }
  }
}
