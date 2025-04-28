import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/providers/state_provider/product_liked_provider.dart';


final productLikedAsyncNotifierProvider = AsyncNotifierProvider<ProductLikedNotifier, List<Product>>(ProductLikedNotifier.new);

class ProductLikedNotifier extends AsyncNotifier<List<Product>> {

  @override
  Future<List<Product>> build() async {
    final productLikedService = ref.watch(productLikedServiceProvider);
    final products = await productLikedService.getLikedProducts();
    return products;
  }
  Future<void> like(String productId) async{
    final productLikedService = ref.watch(productLikedServiceProvider);
    await productLikedService.likeProduct(productId);
    final products = await productLikedService.getLikedProducts();
    state = AsyncData(products);
  }
  Future<void> unlike(String productId) async{
    final productLikedService = ref.watch(productLikedServiceProvider);
    await productLikedService.unlikeProduct(productId);
    final products = await productLikedService.getLikedProducts();
    state = AsyncData(products);
  }
}