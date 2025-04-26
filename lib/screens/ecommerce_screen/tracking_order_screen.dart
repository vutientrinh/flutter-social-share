import 'package:flutter/material.dart';

// Define your enum
enum ShippingStatus {
  PENDING,
  PICKED_UP,
  IN_TRANSIT,
  DELIVERED,
  FAILED,
}

// Example order model
class Order {
  final String id;
  final String title;
  final ShippingStatus status;

  Order({required this.id, required this.title, required this.status});
}

class TrackingShippingScreen extends StatefulWidget {
  const TrackingShippingScreen({super.key});

  @override
  State<TrackingShippingScreen> createState() => _TrackingShippingScreenState();
}

class _TrackingShippingScreenState extends State<TrackingShippingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Example list of orders (replace with API call)
  final List<Order> _orders = [
    Order(id: '1', title: 'Order #1', status: ShippingStatus.PENDING),
    Order(id: '2', title: 'Order #2', status: ShippingStatus.PICKED_UP),
    Order(id: '3', title: 'Order #3', status: ShippingStatus.IN_TRANSIT),
    Order(id: '4', title: 'Order #4', status: ShippingStatus.DELIVERED),
    Order(id: '5', title: 'Order #5', status: ShippingStatus.FAILED),
    Order(id: '6', title: 'Order #6', status: ShippingStatus.PENDING),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ShippingStatus.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getStatusLabel(ShippingStatus status) {
    switch (status) {
      case ShippingStatus.PENDING:
        return 'Pending';
      case ShippingStatus.PICKED_UP:
        return 'Picked Up';
      case ShippingStatus.IN_TRANSIT:
        return 'In Transit';
      case ShippingStatus.DELIVERED:
        return 'Delivered';
      case ShippingStatus.FAILED:
        return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Orders'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: ShippingStatus.values.map((status) {
            return Tab(text: _getStatusLabel(status));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: ShippingStatus.values.map((status) {
          final ordersByStatus = _orders.where((order) => order.status == status).toList();
          if (ordersByStatus.isEmpty) {
            return const Center(child: Text('No orders'));
          }
          return ListView.builder(
            itemCount: ordersByStatus.length,
            itemBuilder: (context, index) {
              final order = ordersByStatus[index];
              return ListTile(
                leading: CircleAvatar(child: Text(order.id)),
                title: Text(order.title),
                subtitle: Text('Status: ${_getStatusLabel(order.status)}'),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
