import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_client.dart';
import '../../services/ecommerce/product_review_service.dart';

final productReviewProvider = Provider<ProductReviewService>((ref) {
  final dio = ref.watch(apiClientProvider);
  return ProductReviewService(dio);
});
