import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/order_history.dart';

// Define your enum
const List<String> shippingStatuses = [
  'PENDING',
  'SHIPPED',
  'DELIVERED',
  'FAILED',
  'CANCELLED',
];

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
    loadData();
  }

  Future<void> loadData() async {
    final response = await ref.read(authServiceProvider).getSavedData();
    ref
        .read(orderAsyncNotifierProvider.notifier)
        .getAllOrders(response['userId']);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getStatusLabel(String status) {
    return status[0] + status.substring(1).toLowerCase(); // PENDING -> Pending
  }


  @override
  Widget build(BuildContext context) {
    final orderAsyncValue = ref.watch(orderAsyncNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Orders'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: shippingStatuses.map((status) {
            return Tab(text:status);
          }).toList(),
        ),

        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderHistory()),
                );
              },
              child: Text("Order history"))
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
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(order.orderCode[0])),
                    title: Text(order.orderCode),
                    subtitle: Text('Status: ${(order.status)}'),
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
