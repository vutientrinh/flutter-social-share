import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/providers/state_provider/product_provider.dart';

import '../state_provider/product_liked_provider.dart';

final productAsyncNotifierProvider =
    AsyncNotifierProvider<ProductNotifier, List<Product>>(ProductNotifier.new);

class ProductNotifier extends AsyncNotifier<List<Product>> {
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isFetchingMore = false;
  bool _hasNextPage = true;

  @override
  Future<List<Product>> build() async {
    return await getProducts(reset: true);
  }

  Future<List<Product>> getProducts(
      {bool reset = false,
      String? search,
      String? category,
      String? minPrice,
      String? maxPrice,
      num? rating,
      String? inStock,
      String? field,
      String? direction}) async {
    final productService = ref.watch(productServiceProvider);
    if (reset) {
      _currentPage = 1;
      _hasNextPage = true;
    }

    final products = await productService.getAllProduct(
      page: _currentPage,
      size: _pageSize,
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
      inStock: inStock,
      field: field,
      direction: direction,
    );
    if (products.length < _pageSize) {
      _hasNextPage = false;
    }
    return products;
  }

  Future<void> getNextProductPage({
    String? search,
    String? category,
    String? minPrice,
    String? maxPrice,
    num? rating,
    String? inStock,
    String? field,
    String? direction,
    bool reset = false, // Add reset parameter
  }) async {
    if (_isFetchingMore || (!reset && !_hasNextPage)) return;
    _isFetchingMore = true;

    if (reset) {
      _currentPage = 1; // Reset pagination
      _hasNextPage = true;
      state = const AsyncData([]); // Clear current products
    } else {
      _currentPage++;
    }

    try {
      final productService = ref.watch(productServiceProvider);
      final newProducts = await productService.getAllProduct(
        page: _currentPage,
        size: _pageSize,
        search: search,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        rating: rating,
        inStock: inStock,
        field: field,
        direction: direction,
      );

      if (newProducts.length < _pageSize) {
        _hasNextPage = false;
      }

      final currentProducts = reset ? [] : (state.value ?? []);
      state = AsyncData([...currentProducts, ...newProducts]);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<Product> getProductById(String productId) async {
    final productService = ref.watch(productServiceProvider);
    final product = await productService.getProductById(productId);
    return product;
  }
}
