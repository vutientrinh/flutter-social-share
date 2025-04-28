import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/category.dart';
import 'package:flutter_social_share/providers/state_provider/category_provider.dart';

final categoryAsyncNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, List<Category>>(
        CategoryNotifier.new);

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() async {
    final categoryService = ref.watch(categoryServiceProvider);
    final categories = await categoryService.getAllCategories();
    return categories;
  }
}
