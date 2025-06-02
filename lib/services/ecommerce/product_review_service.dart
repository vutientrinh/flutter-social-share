import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/product_review.dart';

class ProductReviewService {
  final Dio _dio;

  ProductReviewService(this._dio);

  // Add a comment to a product
  Future<ProductReview> comment({
    required String productId,
    required String author,
    required String comment,
    required int rating,
  }) async {
    try {
      final response = await _dio.post(
        '/api/products/comment',
        data: {
          'productId': productId,
          'author': author,
          'comment': comment,
          'rating': rating,
        },
      );

      if (response.statusCode == 200) {
        return ProductReview.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to submit comment');
      }
    } catch (e) {
      throw Exception('Error submitting comment: $e');
    }
  }

  Future<List<ProductReview>> getComments({
    required String productId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/api/products/comment/$productId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data']['data'];
        return data.map((json) => ProductReview.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch comments');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }
}
