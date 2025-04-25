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
    print("cart item ne ${cartItems}");
    return cartItems;
  }
}
