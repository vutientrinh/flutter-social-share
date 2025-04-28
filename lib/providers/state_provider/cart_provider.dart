import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/api_client.dart';
import 'package:flutter_social_share/services/ecommerce/cart_service.dart';

final cartServiceProvider = Provider<CartService>((ref) {
  final _dio = ref.watch(apiClientProvider);
  return CartService(_dio);
});
