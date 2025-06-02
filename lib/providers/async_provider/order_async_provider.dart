import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/order_request.dart';
import 'package:flutter_social_share/model/ecommerce/order_response.dart';
import 'package:flutter_social_share/providers/state_provider/order_provider.dart';

import '../../model/ecommerce/order_detail_response.dart';

final orderAsyncNotifierProvider =
    AsyncNotifierProvider<OrderNotifier, List<OrderResponse>>(
        OrderNotifier.new);

class OrderNotifier extends AsyncNotifier<List<OrderResponse>> {
  @override
  Future<List<OrderResponse>> build() async {
    return [];
  }

  Future<void> getAllOrders(String userId, {String? status}) async {
    final orderService = ref.watch(orderServiceProvider);
    final orders = await orderService.getAllOrders(customerId: userId, status: status);
    state = AsyncData(orders);
  }

  Future<Response> createOrder(OrderRequest orderRequest) async {
    final orderService = ref.watch(orderServiceProvider);
    final order = await orderService.createOrder(orderRequest: orderRequest);
    return order;
  }
  Future<String> rePayment(String orderId) async {
    final orderService = ref.watch(orderServiceProvider);
    final order = await orderService.rePayment(orderId);
    return order;
  }
  Future<void> cancelOrder(String orderId, String userId) async {
    final orderService = ref.watch(orderServiceProvider);
    await orderService.cancelOrder(orderId);
    final orders = await orderService.getAllOrders(customerId: userId);
    state = AsyncData(orders);
  }
}
