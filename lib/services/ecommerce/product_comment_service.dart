import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/product_comment_response.dart';

class ProductCommentService {
  final Dio _dio;

  ProductCommentService(this._dio);

  /// Post a product comment
  Future<ProductCommentResponse?> postComment({
    required String productId,
    required String content,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/products/comment',
        data: {
          "productId": productId,
          "content": content,
          "userId": userId,
        },
      );

      if (response.statusCode == 200) {
        return ProductCommentResponse.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print("Dio error posting comment: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error posting comment: $e");
      return null;
    }
  }

  /// Get comments by product ID with optional pagination
  Future<List<ProductCommentResponse>> getComments({
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
        final List data = response.data['data'];
        return data
            .map((json) => ProductCommentResponse.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      print("Dio error getting comments: ${e.message}");
      return [];
    } catch (e) {
      print("Unexpected error getting comments: $e");
      return [];
    }
  }
}
