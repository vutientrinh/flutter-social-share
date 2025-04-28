import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/address_request.dart';
import 'package:flutter_social_share/providers/async_provider/address_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/shipping_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateAddressScreen extends ConsumerStatefulWidget {
  const CreateAddressScreen({super.key});

  @override
  ConsumerState<CreateAddressScreen> createState() => _CreateAddressState();
}

class _CreateAddressState extends ConsumerState<CreateAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();

  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];

  int? selectedProvinceId;
  int? selectedDistrictId;
  String? selectedWardCode;
  String? selectedProvinceName;
  String? selectedDistrictName;
  String? selectedWardName;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    final shippingService = ref.read(shippingProvider);
    final res = await shippingService.getProvinces();
    setState(() {
      provinces = res.data['data'];
    });
  }

  Future<void> _loadDistricts(int provinceId) async {
    final shippingService = ref.read(shippingProvider);
    final res = await shippingService.getDistricts(provinceId);
    setState(() {
      districts = res.data['data'];
      selectedDistrictId = null;
      selectedDistrictName = null;
      wards = [];
      selectedWardCode = null;
      selectedWardName = null;
    });
  }

  Future<void> _loadWards(int districtId) async {
    final shippingService = ref.read(shippingProvider);
    final res = await shippingService.getWards(districtId);
    setState(() {
      wards = res.data['data'];
      selectedWardCode = null;
      selectedWardName = null;
    });
  }

  void _submitForm() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();

    if (_formKey.currentState!.validate() &&
        selectedProvinceId != null &&
        selectedDistrictId != null &&
        selectedWardCode != null) {

      final address = AddressRequest(
        userId: data['userId'],
        phone: phoneController.text,
        address: detailController.text,
        wardCode: selectedWardCode!,
        wardName: selectedWardName!,
        districtId: selectedDistrictId!,
        districtName: selectedDistrictName!,
        provinceId: selectedProvinceId!,
        provinceName: selectedProvinceName!,
      );

      print("Submitting address: $address");
      await ref.read(addressAsyncNotifierProvider.notifier).createAddress(address);
    } else {
      print("Form incomplete");
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: Colors.blue, fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<dynamic> items,
    required void Function(T?) onChanged,
    required String displayField,
    required String idField,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map<DropdownMenuItem<T>>((item) {
        return DropdownMenuItem<T>(
          value: item[idField] as T,
          child: Text(item[displayField]),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: _inputDecoration(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration('Full Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: _inputDecoration('Phone Number'),
                  validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildDropdown<int>(
                  label: 'Province',
                  value: selectedProvinceId,
                  items: provinces,
                  onChanged: (value) {
                    setState(() {
                      selectedProvinceId = value;
                      selectedProvinceName = provinces.firstWhere((p) => p['ProvinceID'] == value)['ProvinceName'];
                      selectedDistrictId = null;
                      selectedDistrictName = null;
                      selectedWardCode = null;
                      selectedWardName = null;
                      districts = [];
                      wards = [];
                    });
                    if (value != null) _loadDistricts(value);
                  },
                  displayField: 'ProvinceName',
                  idField: 'ProvinceID',
                ),
                const SizedBox(height: 16),
                _buildDropdown<int>(
                  label: 'District',
                  value: selectedDistrictId,
                  items: districts,
                  onChanged: (value) {
                    setState(() {
                      selectedDistrictId = value;
                      selectedDistrictName = districts.firstWhere((d) => d['DistrictID'] == value)['DistrictName'];
                      selectedWardCode = null;
                      selectedWardName = null;
                      wards = [];
                    });
                    if (value != null) _loadWards(value);
                  },
                  displayField: 'DistrictName',
                  idField: 'DistrictID',
                ),
                const SizedBox(height: 16),
                _buildDropdown<String>(
                  label: 'Ward',
                  value: selectedWardCode,
                  items: wards,
                  onChanged: (value) {
                    setState(() {
                      selectedWardCode = value;
                      selectedWardName = wards.firstWhere((w) => w['WardCode'] == value)['WardName'];
                    });
                  },
                  displayField: 'WardName',
                  idField: 'WardCode',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: detailController,
                  decoration: _inputDecoration('Detail Address (Street, Building...)'),
                  validator: (value) => value!.isEmpty ? 'Please enter detail address' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Address'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
