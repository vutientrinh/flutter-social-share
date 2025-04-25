import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/cart_provider.dart';

final cartAsyncNotifierProvider =
    AsyncNotifierProvider<CartNotifier, List<CartResponse>>(CartNotifier.new);

class CartNotifier extends AsyncNotifier<List<CartResponse>> {
  @override
  Future<List<CartResponse>> build() async {
    final authService = ref.watch(authServiceProvider);
    final data = await authService.getSavedData();

    return await getCartItems(data['userId']);
  }

  Future<List<CartResponse>> getCartItems(String userId) async {
    final cartService = ref.watch(cartServiceProvider);
    final cartItems = await cartService.getCartItems(userId);
    return cartItems;
  }

  Future<void> addToCart(
      String userId, String productId, num price, int quantity) async {
    final cartService = ref.watch(cartServiceProvider);

    await cartService.addToCart(
        userId: userId, productId: productId, price: price, quantity: quantity);

    final cartItems = await getCartItems(userId);

    // ✅ THIS is what was missing
    state = AsyncValue.data(cartItems);
  }

  Future<void> clearCart(
      String userId) async {
    final cartService = ref.watch(cartServiceProvider);

    await cartService.clearCart(userId);

    final cartItems = await getCartItems(userId);

    // ✅ THIS is what was missing
    state = AsyncValue.data(cartItems);
  }

}
