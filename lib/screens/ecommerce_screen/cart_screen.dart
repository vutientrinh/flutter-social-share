import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/providers/async_provider/cart_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final authService = ref.watch(authServiceProvider);
    final data = await authService.getSavedData();
    Future.microtask(() {
      ref.read(cartAsyncNotifierProvider.notifier).getCartItems(data['userId']);
    });
  }

  // List<Map<String, dynamic>> cartItems = [
  //   {"name": "Product 1", "price": 20.0, "quantity": 1},
  //   {"name": "Product 2", "price": 15.5, "quantity": 2},
  //   {"name": "Product 3", "price": 10.0, "quantity": 1},
  // ];
  void increaseQuantity(String cartItemId) {
    // ref.read(cartAsyncNotifierProvider.notifier).increaseQuantity(cartItemId);
  }

  void decreaseQuantity(String cartItemId) {
    // ref.read(cartAsyncNotifierProvider.notifier).decreaseQuantity(cartItemId);
  }

  void removeItem(String cartItemId) {
    // ref.read(cartAsyncNotifierProvider.notifier).removeItem(cartItemId);
  }

  double getTotalPrice(List<CartResponse> items) {
    return items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(item.product.name),
                        subtitle: Text(
                            "Price: \$${item.product.price.toStringAsFixed(2)}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {},
                            ),
                            Text("${item.quantity}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Total: \$${getTotalPrice(items).toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle checkout
                      },
                      child: const Text("Proceed to Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
