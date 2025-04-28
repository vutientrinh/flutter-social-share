import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/address.dart';
import 'package:flutter_social_share/model/ecommerce/address_request.dart';
import 'package:flutter_social_share/providers/state_provider/address_provider.dart';

final addressAsyncNotifierProvider =
    AsyncNotifierProvider<AddressNotifier, List<Address>>(AddressNotifier.new);

class AddressNotifier extends AsyncNotifier<List<Address>> {
  @override
  Future<List<Address>> build() async {
    return await getAddress();
  }

  Future<List<Address>> getAddress() async {
    final addressService = ref.watch(addressServiceProvider);
    return await addressService.getAllAddresses();
  }

  Future<void> createAddress(AddressRequest addressRequest) async {
    final addressService = ref.watch(addressServiceProvider);
    await addressService.createAddress(addressRequest);
    final address = await getAddress();
    state = AsyncData(address);
  }

  Future<void> updateAddress(String id, AddressRequest addressRequest) async {
    final addressService = ref.watch(addressServiceProvider);
    await addressService.updateAddress(id, addressRequest);
    final address = await getAddress();
    state = AsyncData(address);
  }

  Future<void> deleteAddress(String id) async {
    final addressService = ref.watch(addressServiceProvider);
    await addressService.deleteAddress(id);
    final address = await getAddress();
    state = AsyncData(address);
  }

  Future<void> setDefaultAddress(String id) async {
    final addressService = ref.watch(addressServiceProvider);
    await addressService.setDefaultAddress(id);
    final address = await getAddress();
    state = AsyncData(address);
  }
}
