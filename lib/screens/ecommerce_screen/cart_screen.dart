import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/providers/async_provider/address_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/cart_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/mock_data/shipping_option.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:intl/intl.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? userId;
  final TextEditingController _addressController = TextEditingController();
  String _paymentMethod = 'cash';
  num shippingFee = 0;

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
      ref.read(addressAsyncNotifierProvider.notifier).getAddress();
    });
  }

  void increaseQuantity(CartResponse item, int quantity) {
    ref
        .read(cartAsyncNotifierProvider.notifier)
        .addToCart(userId!, item.product.id, item.product.price, quantity);
  }

  void decreaseQuantity(CartResponse item, int quantity) {
    ref
        .read(cartAsyncNotifierProvider.notifier)
        .addToCart(userId!, item.product.id, item.product.price, quantity);
  }

  double getTotalPrice(List<CartResponse> items) {
    return items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double calculateWeightItems(List<CartResponse> items) {
    return items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartAsyncNotifierProvider);
    final addressState = ref.watch(addressAsyncNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }
          return SingleChildScrollView(
              // padding: const EdgeInsets.all(12),
              child: Column(
            children: [
              ListView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        if (item.quantity >= 2)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              decreaseQuantity(item, -1);
                                            },
                                          ),
                                        if (item.quantity < 2)
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {},
                                          ),
                                        Text("${item.quantity}"),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            increaseQuantity(item, 1);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            decreaseQuantity(
                                                item, -item.quantity);
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "₫${NumberFormat("#,###", "vi_VN").format(item.price)}",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 16),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Shipping Address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextButton(
                      onPressed: () {
                        // TODO: Handle change address logic
                      },
                      child: const Text(
                        "Add more",
                        style: TextStyle(color: Colors.black),
                      ),
                      // style: ButtonStyle(),
                    ),
                    addressState.when(
                      data: (addresses) {
                        if (addresses.isEmpty) {
                          return const Text("No address found");
                        }

                        return Column(
                          children: addresses.map((address) {
                            final user = address.user;
                            final isDefault = address.isDefault;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Red signal if default
                                    if (isDefault)
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    else
                                      const SizedBox(width: 18),

                                    // Address details and actions
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Name and phone row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${user.firstName} ${user.lastName}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text("📞 ${address.phone}"),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(address.address),
                                          Text(
                                              '${address.wardName}, ${address.districtName}, ${address.provinceName}'),
                                          const SizedBox(height: 8),

                                          // Actions
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (!isDefault)
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    // TODO: Handle set default logic
                                                  },
                                                  icon: const Icon(
                                                    Icons.check_circle_outline,
                                                    size: 18,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    "Set Default",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textStyle: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              if (!isDefault)
                                                const SizedBox(width: 8),
                                              if (!isDefault)
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red),
                                                  tooltip: 'Delete address',
                                                  onPressed: () {
                                                    // TODO: Handle delete logic
                                                  },
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Shipping Option",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: shippingOptions.map((option) {
                        final isSelected = option['selected'] == true;
                        return GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   for (var opt in shippingOptions) {
                            //     opt['selected'] = (opt['id'] == option['id']);
                            //   }
                            //   _selectedShippingId = option['id'];
                            // });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade200,
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.blue.shade900
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  option['options'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.blueGrey
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Payment Method",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    RadioListTile(
                      value: 'cash',
                      groupValue: _paymentMethod,
                      title: const Text('Cash on Delivery'),
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      value: 'VN Pay',
                      groupValue: _paymentMethod,
                      title: const Text('VN Pay'),
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Total : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
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
                          backgroundColor: Colors.blue,
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
          ));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
