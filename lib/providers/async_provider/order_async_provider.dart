import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/order_request.dart';
import 'package:flutter_social_share/model/ecommerce/order_response.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/providers/state_provider/order_provider.dart';
import 'package:flutter_social_share/providers/state_provider/product_provider.dart';

final orderAsyncNotifierProvider =
    AsyncNotifierProvider<OrderNotifier, List<OrderResponse>>(
        OrderNotifier.new);

class OrderNotifier extends AsyncNotifier<List<OrderResponse>> {
  @override
  Future<List<OrderResponse>> build() async {
    return [];
  }

  Future<void> getAllOrders(String userId) async {
    final orderService = ref.watch(orderServiceProvider);
    final orders = await orderService.getAllOrders(customerId: userId);
    state = AsyncData(orders);
  }
  Future<String> createOrder(OrderRequest orderRequest) async {
    final orderService = ref.watch(orderServiceProvider);
    final order = await orderService.createOrder(orderRequest: orderRequest);
    return order;
  }
}
