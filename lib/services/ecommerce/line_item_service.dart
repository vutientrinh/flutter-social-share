import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/line_item_response.dart';

class LineItemService {
  final Dio _dio;

  LineItemService(this._dio);

  Future<List<LineItemResponse>> getLineItemsByOrderId(String orderId) async {
    try {
      final response = await _dio.get('/api/line-items/$orderId/items');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => LineItemResponse.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load line items');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<LineItemResponse>> addLineItemsToOrder(
      String orderId,
      String productId,
      int price,
      int quantity,
      ) async {
    try {
      final response = await _dio.post(
        '/api/line-items/$orderId/items',
        data: [
          {
            "productId": productId,
            "price": price,
            "quantity": quantity,
          }
        ],
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((item) => LineItemResponse.fromJson(item)).toList();
      } else {
        throw Exception('Failed to add line item');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<bool> deleteLineItem(String orderId, String lineItemId) async {
    try {
      final response =
      await _dio.delete('/api/line-items/$orderId/items/$lineItemId');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
