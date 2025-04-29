import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/providers/state_provider/product_provider.dart';

import '../state_provider/product_liked_provider.dart';

final productAsyncNotifierProvider =
    AsyncNotifierProvider<ProductNotifier, List<Product>>(ProductNotifier.new);

class ProductNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final productService = ref.watch(productServiceProvider);
    final products = await productService.getAllProduct();
    return products;
  }

  Future<void> getProducts(
      {String? search,
      String? category,
      String? minPrice,
      String? maxPrice,
      num? rating,
      String? inStock,
      String? field,
      String? direction}) async {
    final productService = ref.watch(productServiceProvider);
    final products = await productService.getAllProduct(
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
      inStock: inStock,
      field: field,
      direction: direction,
    );
    state = AsyncData(products);
  }

  Future<Product> getProductById(String productId) async {
    final productService = ref.watch(productServiceProvider);
    final product = await productService.getProductById(productId);
    return product;
  }
}
