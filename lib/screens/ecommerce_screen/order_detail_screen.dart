import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/order_detail_response.dart';
import 'package:flutter_social_share/providers/state_provider/order_provider.dart';

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
        print(orderDetail?.id);
      });
    } catch (e) {
      throw Exception('Failed to fetch order by id');
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = orderDetail!;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Order Code: ${order.orderCode ?? 'N/A'}',
            //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // const SizedBox(height: 10),
            // Text('Status: ${order.status ?? 'N/A'}'),
            // const SizedBox(height: 10),
            // Text('Total Amount: \$${order.}'),
            // const SizedBox(height: 10),
            // Text('Shipping Address: ${order.shippingAddress ?? 'N/A'}'),
            // const SizedBox(height: 10),
            // Text('Created At: ${order.createAt != null ? DateTime.tryParse(order.createAt!)?.toLocal().toString() ?? 'Invalid date' : 'N/A'}'),
            // const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
