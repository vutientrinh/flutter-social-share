import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/address.dart';
import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/model/ecommerce/order_request.dart';
import 'package:flutter_social_share/providers/async_provider/address_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/cart_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/product_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/shipping_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/create_address_screen.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? userId;
  String _paymentMethod = 'COD';
  double shippingFee = 0;
  Address? defaultAddress;

  final Map<String, double> summary = {
    'subtotal': 0.0,
    'tax': 0,
    'shipping': 30000.0,
    'discount': 0,
    'total': 0,
  };
  final List<Map<String, dynamic>> shippingOptions = [
    {
      "id": "light",
      "name": "Light Goods",
      "minWeight": 0,
      "maxWeight": 50000,
      "options": "Up to 50kg",
      "selected": true,
      "service_id": 53321,
      "service_type_id": 2,
    },
    {
      "id": "heavy",
      "name": "Heavy Goods",
      "minWeight": 50000,
      "options": "Over 50kg",
      "selected": false,
      "service_id": 53321,
      "service_type_id": 2,
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userId == null) {
      loadData();
      final cartState = ref.watch(cartAsyncNotifierProvider);
      cartState.maybeWhen(
        data: (cartItems) {
          if (cartItems.isNotEmpty) {
            updateOption(cartItems);
          }
        },
        orElse: () {},
      );
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

  void setDefaultAddress(String id) {
    ref.read(addressAsyncNotifierProvider.notifier).setDefaultAddress(id);
  }

  void deleteAddress(String id) {
    ref.read(addressAsyncNotifierProvider.notifier).deleteAddress(id);
  }

  double getTotalPrice(List<CartResponse> items) {
    return items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double calculateWeightItems(List<CartResponse> items) {
    double value = items.fold(
        0, (sum, item) => sum + (item.product.weight * item.quantity));
    return value;
  }

  void updateOption(List<CartResponse> cartItems) {
    double weight = calculateWeightItems(cartItems);
    setState(() {
      for (var option in shippingOptions) {
        final isLight = option['id'] == 'light' && weight <= 50000;
        final isHeavy = option['id'] == 'heavy' && weight > 50000;
        option['selected'] = isLight || isHeavy;
      }
    });
    final selectedOption = shippingOptions.firstWhere((e) => e['selected']);
    calculateShippingFee(selectedOption, cartItems, defaultAddress);
  }

  Future<void> calculateShippingFee(Map<String, dynamic> shippingSelection,
      List<CartResponse> items, Address? defaultAddress) async {
    if (defaultAddress == null) return;

    final request = {
      'shop_id': dotenv.env['GHN_SHOPID'],
      'service_id': shippingSelection['service_id'],
      'service_type_id': shippingSelection['service_type_id'],
      'to_ward_code': defaultAddress.wardCode.toString(),
      'to_district_id': defaultAddress.districtId,
      'weight': calculateWeightItems(items).toInt(),
    };
    try {
      final response = await ref.read(shippingProvider).getShippingFee(request);
      final data = response.data['data']; // ✅ parse correctly
      final fee = data['total'] ?? 0;
      setState(() {
        shippingFee = fee.toDouble();
        summary['shipping'] = shippingFee;
      });
    } catch (e) {
      print('Error calculating shipping fee: $e');
    }
  }

  void calculateSummary(List<CartResponse> items) async {
    final subTotal = getTotalPrice(items);
    const taxRate = 0.08;
    final tax = subTotal * taxRate;
    final discount = subTotal * 0.1;
    final total = subTotal + tax + shippingFee;
    setState(() {
      summary['subtotal'] = subTotal;
      summary['tax'] = tax;
      summary['shipping'] = shippingFee;
      summary['discount'] = discount;
      summary['total'] = total;
    });
  }

  void orderSubmit(List<CartResponse> items) async {
    final List<Map<String, dynamic>> itemList = items.map((item) {
      return {
        "productId": item.product.id,
        "price": item.product.price,
        "quantity": item.quantity,
      };
    }).toList();

    final Map<String, dynamic> shippingInfo = {
      "receiverName": defaultAddress?.user.username ?? '',
      "receiverPhone": defaultAddress?.phone ?? '',
      "address": defaultAddress?.address ?? '',
      "wardCode": defaultAddress?.wardCode ?? '',
      "districtId": defaultAddress?.districtId ?? 0,
      "shippingFee": shippingFee,
      "serviceId": shippingOptions
          .firstWhere((e) => e['selected'] == true)['service_id'],
      "serviceTypeId": shippingOptions
          .firstWhere((e) => e['selected'] == true)['service_type_id'],
      "weight": calculateWeightItems(items).toInt(),
    };

    final request = {
      "customerId": userId,
      "items": itemList,
      "shippingInfo": shippingInfo,
      "payment": {
        "method": _paymentMethod,
        "amountPaid": summary['total'],
      }
    };

    final orderRequest = OrderRequest.fromJson(request);
    final response = await ref
        .read(orderAsyncNotifierProvider.notifier)
        .createOrder(orderRequest);
    print(response.data['data']);
    await Flushbar(
      title: 'Success',
      message: 'Order successfully!',
      backgroundColor: Colors.green,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
    if (_paymentMethod == "COD") {
      Navigator.pop(context);
    } else {
      final uri = Uri.parse(response.data['data']);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch $uri');
      }
    }
    await ref
        .read(productAsyncNotifierProvider.notifier)
        .updateQuantityStock(items);
    await ref.read(cartAsyncNotifierProvider.notifier).clearCart(userId!);
    ref.read(productAsyncNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartAsyncNotifierProvider);

    final addressState = ref.watch(addressAsyncNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
        ),
        child: cartState.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(child: Text("Your cart is empty"));
            }
            updateOption(items);
            calculateSummary(items);
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                                          item.quantity >= 2
                                              ? IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    decreaseQuantity(item, -1);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                          Text("${item.quantity}"),
                                          item.quantity <
                                                  item.product.stockQuantity
                                              ? IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () {
                                                    increaseQuantity(item, 1);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () async {
                                                    await Flushbar(
                                                      message: 'Out of stock',
                                                      backgroundColor:
                                                          Colors.orange,
                                                      flushbarPosition:
                                                          FlushbarPosition.TOP,
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      animationDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  100),
                                                    ).show(context);
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Shipping Address",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAddressScreen(),
                            ),
                          );
                        },
                        label: const Text(
                          "Add more",
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: const Icon(Icons.add, color: Colors.black),
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
                              if (isDefault) {
                                setState(() {
                                  defaultAddress = address;
                                });
                              }
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Red signal if default
                                      if (isDefault)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          width: 18,
                                          // bigger size
                                          height: 18,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.red,
                                              // border color
                                              width: 2, // border thickness
                                            ),
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                // inner filled color
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        const SizedBox(width: 18),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Name and phone row
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${user.firstName} ${user.lastName}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text("📞 ${address.phone}"),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(address.address),
                                            Text(
                                                '${address.wardName}, ${address.districtName}, ${address.provinceName}'),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                if (!isDefault)
                                                  OutlinedButton.icon(
                                                    onPressed: () {
                                                      setDefaultAddress(
                                                          address.id);
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ),
                                                    label: const Text(
                                                      "Set Default",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textStyle:
                                                          const TextStyle(
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
                                                      deleteAddress(address.id);
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
                          return Container(
                            width: MediaQuery.of(context).size.width - 20,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
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
                                if (isSelected)
                                  Text(
                                    "${NumberFormat("#,###", "vi_VN").format(shippingFee)} ₫",
                                  ),
                              ],
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
                        value: 'COD',
                        groupValue: _paymentMethod,
                        title: const Text('Cash on Delivery'),
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        value: 'VNPAY',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal :",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              "${NumberFormat("#,###", "vi_VN").format(summary['subtotal'])} ₫",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Shipping : ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            Text(
                              "${NumberFormat("#,###", "vi_VN").format(summary['shipping'])} ₫",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "VAT (8%): ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            Text(
                              "${NumberFormat("#,###", "vi_VN").format(summary['tax'])} ₫",
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${NumberFormat("#,###", "vi_VN").format(summary['total'])} ₫",
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
                          onPressed: () async {
                            orderSubmit(items);
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
      ),
    );
  }
}
