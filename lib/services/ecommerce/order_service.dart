import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/order_request.dart';
import 'package:flutter_social_share/model/ecommerce/order_response.dart';

import '../../model/ecommerce/order_detail_response.dart';

class OrderService {
  final Dio _dio;

  OrderService(this._dio);

  // Create an order
  Future<Response> createOrder({required OrderRequest orderRequest}) async {
    try {
      final response = await _dio.post(
        '/api/orders/create',
        data: orderRequest.toJson(),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        // Still return the response so you can inspect it
        return e.response!;
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  // Get all orders with optional status filter
  Future<List<OrderResponse>> getAllOrders({
    int? page = 1,
    int? size = 10,
    String? status,
    String? customerId,
  }) async {
    try {
      final response = await _dio.get(
        '/api/orders/all',
        queryParameters: {
          'customerId': customerId,
          'status': status,
        },
      );

      List<OrderResponse> orders = (response.data['data'] as List)
          .map((productJson) => OrderResponse.fromJson(productJson))
          .toList();
      return orders;
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  // Get a single order by ID
  Future<OrderDetailResponse> getOrderById(String id) async {
    try {
      final response = await _dio.get('/api/orders/$id');
      return OrderDetailResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  Future<String> rePayment(String orderId) async {
    try {
      final response = await _dio.post('/api/orders/repayment/$orderId');
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to pre_payment');
      }
    } catch (e) {
      throw Exception('Failed to pre_payment');
    }
  }

  Future<Map<String, dynamic>> cancelOrder(String orderId) async {
    try {
      final response = await _dio.delete('/api/orders/$orderId/cancel-order');
      return response.data;
    } catch (e) {
      throw Exception('Failed to cancel');
    }
  }
}
