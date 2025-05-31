import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/ecommerce/address_request.dart';
import 'package:flutter_social_share/providers/async_provider/address_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/shipping_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart';

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
    setState(() => provinces = res.data['data']);
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

      await ref
          .read(addressAsyncNotifierProvider.notifier)
          .createAddress(address);
      Navigator.pop(context);
    } else {
      VxToast.show(context,
          msg: "Please complete all fields", bgColor: Colors.red.shade300);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: Colors.teal, fontSize: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.teal, width: 2),
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
      isExpanded: true,
      decoration: _inputDecoration(label),
      items: items.map<DropdownMenuItem<T>>((item) {
        return DropdownMenuItem<T>(
          value: item[idField],
          child: Text(item[displayField]),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Add New Address".text.semiBold.white.make(),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: VStack([
            "Personal Information".text.xl.semiBold.make(),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              decoration: _inputDecoration("Phone Number"),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // Allow only digits
                LengthLimitingTextInputFormatter(15),
                // Optional: limit to 15 digits
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                } else if (value.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: detailController,
              decoration: _inputDecoration("Detailed Address"),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            "Select Location".text.xl.semiBold.make(),
            const SizedBox(height: 10),
            _buildDropdown<int>(
              label: "Province",
              value: selectedProvinceId,
              items: provinces,
              displayField: 'ProvinceName',
              idField: 'ProvinceID',
              onChanged: (val) {
                final selected =
                    provinces.firstWhere((e) => e['ProvinceID'] == val);
                selectedProvinceId = val;
                selectedProvinceName = selected['ProvinceName'];
                _loadDistricts(val!);
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown<int>(
              label: "District",
              value: selectedDistrictId,
              items: districts,
              displayField: 'DistrictName',
              idField: 'DistrictID',
              onChanged: (val) {
                final selected =
                    districts.firstWhere((e) => e['DistrictID'] == val);
                selectedDistrictId = val;
                selectedDistrictName = selected['DistrictName'];
                _loadWards(val!);
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown<String>(
              label: "Ward",
              value: selectedWardCode,
              items: wards,
              displayField: 'WardName',
              idField: 'WardCode',
              onChanged: (val) {
                final selected = wards.firstWhere((e) => e['WardCode'] == val);
                selectedWardCode = val;
                selectedWardName = selected['WardName'];
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: "Save Address".text.make(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitForm,
            )
          ]),
        ),
      ),
    );
  }
}
