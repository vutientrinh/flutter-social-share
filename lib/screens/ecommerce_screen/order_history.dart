import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'order_detail_screen.dart'; // Import the OrderDetailScreen

class OrderHistory extends ConsumerStatefulWidget {
  const OrderHistory({super.key});

  @override
  ConsumerState<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends ConsumerState<OrderHistory> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final authData = await ref.read(authServiceProvider).getSavedData();
    ref.read(orderAsyncNotifierProvider.notifier).getAllOrders(authData['userId']);
  }

  @override
  Widget build(BuildContext context) {
    final orderAsyncValue = ref.watch(orderAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orderAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (orders) {
          if (orders == null || orders.isEmpty) {
            return const Center(child: Text('No order history found.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(order.orderCode.substring(0, 1)),
                  ),
                  title: Text(order.orderCode),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${order.status}'),
                      Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Text(order.createdAt.split('T').first), // display date
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(orderId: order.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
