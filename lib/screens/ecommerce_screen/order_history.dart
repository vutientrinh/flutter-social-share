import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:intl/intl.dart';
import '../../model/ecommerce/order_response.dart';
import '../../providers/state_provider/order_provider.dart';
import '../../utils/uidata.dart';
import 'order_detail_screen.dart';

class OrderHistory extends ConsumerStatefulWidget {
  const OrderHistory({super.key});

  @override
  ConsumerState<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends ConsumerState<OrderHistory> {
  List<OrderResponse>? listOrders;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final authData = await ref.read(authServiceProvider).getSavedData();
    final response = await ref
        .read(orderServiceProvider)
        .getAllOrders(customerId: authData['userId'], status: "DELIVERED");

    setState(() {
      listOrders = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.white,
      ),
      body: listOrders == null
          ? const Center(child: Text('No order history.'))
          : listOrders!.isEmpty
              ? const Center(child: Text('No order history.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: listOrders!.length,
                  itemBuilder: (context, index) {
                    final order = listOrders![index];
                    final firstItem =
                        order.items.isNotEmpty ? order.items[0] : null;
                    final imageUrl = firstItem?.product.images[0];
                    final productName = firstItem?.product.name;
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        leading: imageUrl != null
                            ? SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                  LINK_IMAGE.publicImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(
                          "$productName",
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "x ${order.items.length}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  order.payment!.method,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.createdAt.isNotEmpty
                                      ? DateFormat.yMMMd().format(
                                          DateTime.parse(order.createdAt))
                                      : "N/A",
                                ),
                                Text(
                                  "${NumberFormat("#,###", "vi_VN").format(order.payment?.amountPaid)} ₫",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailScreen(orderId: order.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
