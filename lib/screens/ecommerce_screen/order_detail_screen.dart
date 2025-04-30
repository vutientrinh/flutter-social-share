import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId; // Accept orderId as a parameter

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    final response = await ref.read(authServiceProvider).getSavedData();
    ref.read(orderAsyncNotifierProvider.notifier).getOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final orderAsyncValue = ref.watch(orderAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: orderAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Order not found.'));
          }
          print(order);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Order Code: ${order.}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                // SizedBox(height: 10),
                // Text('Status: ${order.status}'),
                // SizedBox(height: 10),
                // Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
                // SizedBox(height: 10),
                // Text('Shipping Address: ${order.shippingAddress}'),
                // SizedBox(height: 10),
                // Text('Created At: ${order.createAt}'),
                SizedBox(height: 10),
                // Add more details as necessary
              ],
            ),
          );
        },
      ),
    );
  }
}
