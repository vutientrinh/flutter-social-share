import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/order_detail_response.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/order_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/widget/shipping_status_bar.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> cancelOrder(
      BuildContext context, OrderDetailResponse order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Cancel"),
        content: const Text("Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref
          .read(orderAsyncNotifierProvider.notifier)
          .cancelOrder(order.id, order.customer.id);

      await Flushbar(
        title: 'Order Cancelled',
        message: 'The order has been successfully cancelled!',
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        animationDuration: const Duration(milliseconds: 300),
      ).show(context);

      // Optionally refresh or pop
      Navigator.pop(context); // go back
    }
  }

  Future<void> rePayment(OrderDetailResponse order) async {
    final response =
        await ref.read(orderAsyncNotifierProvider.notifier).rePayment(order.id);
    final uri = Uri.parse(response);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $uri');
    }
    Navigator.pop(context);
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
                  "Shipping fee :  ",
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
                  "${NumberFormat("#,###", "vi_VN").format(order.payment.amountPaid)} ₫",
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
      bottomSheet:
          order.status == "PENDING" && order.payment.status == "PENDING"
              ? Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            cancelOrder(context, order);
                          },
                          icon: const Icon(Icons.cancel,
                              size: 20, color: Colors.white),
                          label: const Text(
                            "Cancel Order",
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (order.payment.method == "VNPAY")
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              rePayment(order);
                            },
                            icon: const Icon(Icons.payment, size: 20, color: Colors.white),
                            label: const Text(
                              "Payment",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : null,
    );
  }
}
