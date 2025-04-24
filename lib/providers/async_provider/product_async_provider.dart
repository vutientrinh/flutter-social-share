import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/providers/state_provider/product_provider.dart';


final productAsyncNotifierProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(ProductNotifier.new);

class ProductNotifier extends AsyncNotifier<List<Product>> {

  @override
  Future<List<Product>> build() async {
    final productService = ref.watch(productServiceProvider);
    final products = await productService.getAllProduct();
    return products;
  }
}