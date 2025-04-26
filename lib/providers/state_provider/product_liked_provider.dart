import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/ecommerce/product_liked_service.dart';

import '../../services/api_client.dart';
import '../../services/ecommerce/product_service.dart';

final productLikedServiceProvider = Provider<ProductLikedService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ProductLikedService(dio);
});
