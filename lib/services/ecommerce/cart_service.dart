import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/cart_response.dart';

class CartService {
  final Dio _dio;

  CartService(this._dio);

  // Add item to cart
  Future<List<CartResponse>> addToCart({
    required String userId,
    required String productId,
    required num price,
    required int quantity,
  }) async {
    try {
      final response = await _dio.post(
        '/api/cart/$userId/add',
        data: {
          'productId': productId,
          'price': price,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        List<CartResponse> cartItems = (response.data['data'] as List)
            .map((json) => CartResponse.fromJson(json))
            .toList();
        return cartItems;
      } else {
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      throw Exception('Error adding item to cart: $e');
    }
  }

  // Get cart items
  Future<List<CartResponse>> getCartItems(String userId) async {
    try {
      final response = await _dio.get('/api/cart/$userId');
      if (response.statusCode == 200) {
        List<CartResponse> cartItems = (response.data['data'] as List)
            .map((json) => CartResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        return cartItems;
      } else {
        throw Exception('Failed to map cart items');
      }
    } catch (e) {
      throw Exception('Error fetching cart items: $e');
    }
  }

  // Clear cart
  Future<bool> clearCart(String userId) async {
    try {
      final response = await _dio.delete('/api/cart/$userId/clear');
      if (response.statusCode == 200) {
        return response.data['data'] == true;
      } else {
        throw Exception('Failed to clear cart');
      }
    } catch (e) {
      throw Exception('Error clearing cart: $e');
    }
  }
}
