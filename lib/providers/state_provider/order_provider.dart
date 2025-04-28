import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/ecommerce/order_service.dart';
import '../../services/api_client.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return OrderService(dio);
});
