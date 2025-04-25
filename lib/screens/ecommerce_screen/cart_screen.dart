import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/providers/async_provider/cart_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:intl/intl.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? userId;

  // @override
  // void initState() {
  //   super.initState();
  //   loadData();
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userId == null) {
      loadData();
    }
  }

  Future<void> loadData() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    setState(() {
      userId = data['userId'];
    });
    Future.microtask(() {
      ref.read(cartAsyncNotifierProvider.notifier).getCartItems(data['userId']);
    });
  }

  void increaseQuantity(CartResponse item, int quantity) {
    ref.read(cartAsyncNotifierProvider.notifier).addToCart(userId!, item.product.id, item.product.price, quantity);
  }

  void decreaseQuantity(CartResponse item, int  quantity) {
    ref.read(cartAsyncNotifierProvider.notifier).addToCart(userId!, item.product.id, item.product.price, quantity);
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image on the left
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                LINK_IMAGE.publicImage(item.product.images[0]),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Info on the right
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "₫${NumberFormat("#,###", "vi_VN").format(item.price)}",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          decreaseQuantity(item,-1);
                                        },
                                      ),
                                      Text("${item.quantity}"),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          increaseQuantity(item,1);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          decreaseQuantity(item,- item.quantity);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Total : ",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${NumberFormat("#,###", "vi_VN").format(getTotalPrice(items))} ₫",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Handle checkout
                        },
                        icon: const Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "Order",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
