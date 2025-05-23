import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/order_detail_response.dart';
import 'package:flutter_social_share/providers/state_provider/order_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/widget/shipping_status_bar.dart';
import 'package:intl/intl.dart';

import '../../utils/uidata.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  OrderDetailResponse? orderDetail;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final response =
          await ref.read(orderServiceProvider).getOrderById(widget.orderId);
      setState(() {
        orderDetail = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch order by ID';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null || orderDetail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: Center(
          child: Text(errorMessage ?? "Can't load order details."),
        ),
      );
    }

    final order = orderDetail!;
    final paymentAmount = order.payment.amountPaid ?? 0.0;
    final address = order.shippingInfo.address ?? 'N/A';

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ShippingStatusBar(
                status: orderDetail?.shippingInfo.shippingStatus ?? "PENDING"),
            const SizedBox(height: 16),
            const Text(
              "Order information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Order Code: ${order.orderCode}',
            ),
            const SizedBox(height: 8),
            Text(
              'Receiver : ${orderDetail?.customer.firstName} ${orderDetail?.customer.lastName}',
            ),
            const SizedBox(height: 8),
            Text("Shipping address : ${orderDetail!.shippingInfo.address}"),
            const SizedBox(height: 8),
            Text("Phone number : ${orderDetail?.shippingInfo.receiverPhone}"),
            const Divider(height: 32),
            const Text('Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                // Adjust padding value as needed
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image on the left
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        LINK_IMAGE.publicImage(item.product.images[0].filename),
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
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("x ${item.quantity}"),
                                ],
                              ),
                              Text(
                                "₫${NumberFormat("#,###", "vi_VN").format(item.price)}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
            const Divider(height: 32),
            const SizedBox(height: 8),
            const Text(
              "Order payment",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Method :"),
                Text(order.payment.method),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status :"),
                Text(
                  ' ${order.payment.status}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total product :  ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${NumberFormat("#,###", "vi_VN").format(order.shippingFee)} ₫",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payment : ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${NumberFormat("#,###", "vi_VN").format(order.totalAmount)} ₫",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () async {
              // Your logic here
            },
            icon: const Icon(Icons.shopping_cart_outlined,
                size: 20, color: Colors.white),
            label: const Text(
              "Connect with seller",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
