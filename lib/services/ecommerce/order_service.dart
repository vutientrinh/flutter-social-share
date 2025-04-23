import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/order_request.dart';
import 'package:flutter_social_share/model/ecommerce/order_response.dart';

class OrderService {
  final Dio _dio;

  OrderService(this._dio);

  // Create an order
  Future<String> createOrder({
    required OrderRequest orderRequest

  }) async {
    try {
      final response = await _dio.post(
        '/api/orders/create',
        data: {
          'customerId': orderRequest.customerId,
          'items': orderRequest.items,
          'shippingInfo': orderRequest.shippingInfo,
          'payment': orderRequest.payment,
        },
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  // Get all orders with optional status filter
  Future<List<OrderResponse>> getAllOrders({
    required String customerId,
    int page = 1,
    int size = 10,
    String? status, // Optional
  }) async {
    try {
      final response = await _dio.get(
        '/api/orders/all',
        queryParameters: {
          'page': page,
          'size': size,
          'customerId': customerId,
          if (status != null) 'status': status,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data']['content'];
        return data.map((json) => OrderResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  // Get a single order by ID
  Future<OrderResponse> getOrderById(String id) async {
    try {
      final response = await _dio.get('/api/orders/$id');

      if (response.statusCode == 200) {
        return OrderResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch order');
      }
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }
}
