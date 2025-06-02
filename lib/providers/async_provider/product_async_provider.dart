import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/providers/state_provider/product_provider.dart';

import '../../model/ecommerce/cart_response.dart';
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
  Future<void> updateProductRating(Product productCurrent, int newRating) async {
    final products = state.value;
    if (products == null) return;

    // Create updated list of products
    final updatedProducts = products.map((product) {
      if (product.id == productCurrent.id) {
        final currentAmountRating = product.amountRating;
        final currentTotalRating = product.rating * currentAmountRating;

        final newAmountRating = currentAmountRating + 1;
        final newTotalRating = currentTotalRating + newRating;
        final newCalculatedRating = newTotalRating / newAmountRating;

        return product.copyWith(
          rating: newCalculatedRating,
          amountRating: newAmountRating,
        );
      }
      return product;
    }).toList();

    state = AsyncValue.data(updatedProducts);
  }
  Future<void> updateLike(Product productCurrent, bool like) async {
    final products = state.value;
    if (products == null) return;

    // Create updated list of products
    final updatedProducts = products.map((product) {
      if (product.id == productCurrent.id) {

        return product.copyWith(
          isLiked: like,
        );
      }
      return product;
    }).toList();

    state = AsyncValue.data(updatedProducts);
  }
  Future<void> updateQuantityStock(List<CartResponse> orderedItems) async {
    final products = state.value;
    if (products == null) return;

    // Update the quantity of each product in the order
    final updatedProducts = products.map((product) {
      // Find the matching ordered item
      final orderedItem = orderedItems.firstWhere(
            (item) => item.product.id == product.id,

      );

      if (orderedItem != null) {
        // Calculate new stock quantity
        final newStockQuantity = product.stockQuantity - orderedItem.quantity;
        return product.copyWith(
          stockQuantity: newStockQuantity >= 0 ? newStockQuantity : 0,
        );
      }
      return product;
    }).toList();

    state = AsyncValue.data(updatedProducts);
  }


}
