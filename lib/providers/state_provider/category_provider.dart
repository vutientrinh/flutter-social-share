import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/services/api_client.dart';
import 'package:flutter_social_share/services/ecommerce/category_service.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  final _dio = ref.watch(apiClientProvider);
  return CategoryService(_dio);
});
