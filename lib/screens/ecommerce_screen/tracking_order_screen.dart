import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/order_history.dart';
import 'package:intl/intl.dart';

import '../../utils/uidata.dart';
import 'order_detail_screen.dart';

const List<String> shippingStatuses = [
  'PENDING',
  'SHIPPED',
  'DELIVERED',
  'FAILED',
  'CANCELLED',
];

final Map<String, Color> statusColors = {
  'PENDING': Colors.orange,
  'SHIPPED': Colors.blue,
  'DELIVERED': Colors.green,
  'FAILED': Colors.red,
  'CANCELLED': Colors.grey,
};

class TrackingShippingScreen extends ConsumerStatefulWidget {
  const TrackingShippingScreen({super.key});

  @override
  ConsumerState<TrackingShippingScreen> createState() =>
      _TrackingShippingScreenState();
}

class _TrackingShippingScreenState extends ConsumerState<TrackingShippingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: shippingStatuses.length, vsync: this);
    Future.microtask(() async {
      final response = await ref.read(authServiceProvider).getSavedData();
      await ref
          .read(orderAsyncNotifierProvider.notifier)
          .getAllOrders(response['userId'],);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getStatusLabel(String status) {
    return status[0] + status.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final orderAsyncValue = ref.watch(orderAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          // isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          // padding: EdgeInsets.zero, // Remove default outer padding
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          // Optional spacing between tabs
          tabs: shippingStatuses.map((status) {
            return Tab(text: _getStatusLabel(status));
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderHistory()));
            },
            child: const Text("Order History",
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: orderAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (orders) {
          if (orders == null || orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return TabBarView(
            controller: _tabController,
            children: shippingStatuses.map((status) {
              final filteredOrders =
                  orders.where((o) => o.status == status).toList();

              if (filteredOrders.isEmpty) {
                return const Center(child: Text('No orders'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
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
                                "x ${firstItem?.quantity}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                order!.payment!.method,
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
                                    ? DateFormat.yMMMd()
                                        .format(DateTime.parse(order.createdAt))
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
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
