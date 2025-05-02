import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/ecommerce/address.dart';
import '../../providers/async_provider/address_async_provider.dart';
import 'create_address_screen.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  Address? defaultAddress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    Future.microtask(() {
      ref.read(addressAsyncNotifierProvider.notifier).getAddress();
    });
  }

  void _setDefaultAddress(String id) {
    ref.read(addressAsyncNotifierProvider.notifier).setDefaultAddress(id);
  }

  void _deleteAddress(String id) {
    ref.read(addressAsyncNotifierProvider.notifier).deleteAddress(id);
  }

  Widget _buildAddressCard(Address address) {
    final user = address.user;
    final isDefault = address.isDefault;

    if (isDefault) defaultAddress = address;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDefault)
              _buildDefaultIndicator()
            else
              const SizedBox(width: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameAndPhone(user.firstName, user.lastName, address.phone),
                  const SizedBox(height: 6),
                  Text(address.address),
                  Text('${address.wardName}, ${address.districtName}, ${address.provinceName}'),
                  const SizedBox(height: 10),
                  _buildActionsRow(isDefault, address.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIndicator() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: const Center(
        child: CircleAvatar(
          radius: 5,
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  Widget _buildNameAndPhone(String firstName, String lastName, String phone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$firstName $lastName',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text("📞 $phone"),
      ],
    );
  }

  Widget _buildActionsRow(bool isDefault, String id) {
    if (isDefault) return const SizedBox.shrink();

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () => _setDefaultAddress(id),
          icon: const Icon(Icons.check_circle_outline, size: 18, color: Colors.black),
          label: const Text("Set Default", style: TextStyle(color: Colors.black)),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: 'Delete address',
          onPressed: () => _deleteAddress(id),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: addressState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (addresses) {
          if (addresses.isEmpty) {
            return const Center(child: Text("No addresses found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return _buildAddressCard(addresses[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateAddressScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new address',
      ),
    );
  }
}
