import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/ecommerce/shipping_service.dart';
import '../../services/api_client.dart';

final shippingProvider = Provider<ShippingService>((ref) {
  final dio = ref.watch(shippingApiClientProvider);
  return ShippingService(dio);
});
