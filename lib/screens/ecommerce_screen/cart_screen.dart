import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/providers/async_provider/address_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/cart_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/shipping_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/create_address_screen.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? userId;
  String _paymentMethod = 'COD';
  num shippingFee = 0;

  final Map<String, double> summary = {
    'subtotal': 0,
    'tax': 0,
    'shipping': 30000,
    'discount': 0,
    'total': 0,
  };
  final List<Map<String, dynamic>> shippingOptions = [
    {
      "id": "light",
      "name": "Hàng nhẹ",
      "minWeight": 0,
      "maxWeight": 50000,
      "options": "Tối đa 50kg",
      "selected": true,
      "service_id": 53321,
      "service_type_id": 2,
    },
    {
      "id": "heavy",
      "name": "Hàng nặng",
      "minWeight": 50000,
      "options": "Trên 50kg",
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
    return items.fold(0, (sum, item) => sum + (item.product.weight));
  }

  void updateOption(List<CartResponse> cartItems, {String? manualSelectedId}) {
    final double weight = calculateWeightItems(cartItems);

    setState(() {
      for (var option in shippingOptions) {
        // If manually selected by user
        if (manualSelectedId != null) {
          option['selected'] = option['id'] == manualSelectedId;
        } else {
          // Auto-select based on weight
          if (option['id'] == 'light' && weight <= 50000) {
            option['selected'] = true;
          } else if (option['id'] == 'heavy' && weight > 50000) {
            option['selected'] = true;
          } else {
            option['selected'] = false;
          }
        }
      }
    });

    // After selecting option, calculate shipping fee
    final selectedOption = shippingOptions.firstWhere(
      (option) => option['selected'] == true,
      orElse: () => {},
    );

    if (selectedOption.isNotEmpty) {
      calculateShippingFee(selectedOption, cartItems);
    } else {
      setState(() {
        shippingFee = 0;
        summary['shipping'] = 0;
      });
    }
  }

  Future<void> calculateShippingFee(
      Map<String, dynamic> shippingSelection, List<CartResponse> items) async {
    final request = {
      'shop_id': dotenv.env['GHN_SHOPID'],
      'service_id': shippingSelection['service_id'],
      'service_type_id': shippingSelection['service_type_id'],
      'to_ward_code': shippingSelection['wardCode'], // make sure you pass these
      'to_district_id': shippingSelection['districtId'],
      'weight': calculateWeightItems(items),
    };
    try {
      final response = await ref.read(shippingProvider).getShippingFee(request);
      final data = response.data;
      setState(() {
        shippingFee = data['total']; // assume total shipping fee comes here
        summary['shipping'] = shippingFee.toDouble();
      });
    } catch (e) {
      print('Error calculating shipping fee: $e');
    }
    final subTotal = getTotalPrice(items);
    const taxRate = 0.08;
    final tax = subTotal * taxRate;
    final discount = subTotal * 0.1;
    final total = subTotal + tax + shippingFee - discount;
    // return
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
          calculateShippingFee(shippingOptions[0], items);
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
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAddressScreen()),
                        )
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${user.firstName} ${user.lastName}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (!isDefault)
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    setDefaultAddress(
                                                        address.id);
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
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: (MediaQuery.of(context).size.width) - 20,
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
                        onPressed: () async {
                          final url = Uri.parse(
                              "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=19990000&vnp_Command=pay&vnp_CreateDate=20250427191825&vnp_CurrCode=VND&vnp_ExpireDate=20250427193325&vnp_IpAddr=127.0.0.1&vnp_Locale=vn&vnp_OrderInfo=8dddef94-234c-420b-b010-62bc5992e942&vnp_OrderType=order-type&vnp_ReturnUrl=http%3A%2F%2Flocalhost%3A8080%2Fvnpay-payment&vnp_TmnCode=44SQ7IET&vnp_TxnRef=54997949&vnp_Version=2.1.0&vnp_SecureHash=eafd5f748f6a35b0e3e3d91b157b0161f96045dad9ce36e207b1f4c864ba85bd6da9521a3881d219b4d32e6e57d18c0f02fdfded6fa3a3012b1dece8b427226d");
                          try {
                            print(await canLaunchUrl(url));
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication); // open in external browser
                            } else {
                              throw 'Could not launch $url';
                            }
                          } catch (e) {
                            print(e.toString());
                          }

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
