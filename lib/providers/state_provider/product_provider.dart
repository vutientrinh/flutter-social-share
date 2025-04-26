import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_client.dart';
import '../../services/ecommerce/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ProductService(dio);
});
