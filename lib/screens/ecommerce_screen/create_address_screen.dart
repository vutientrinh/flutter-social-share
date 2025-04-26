import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/shipping_provider.dart';

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

  String? selectedProvinceId;
  String? selectedDistrictId;
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

  Future<void> _loadDistricts(String provinceId) async {
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

  Future<void> _loadWards(String districtId) async {
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
    final data =
        await authService.getSavedData(); // fixed typo `date` -> `data`

    if (_formKey.currentState!.validate() &&
        selectedProvinceId != null &&
        selectedDistrictId != null &&
        selectedWardCode != null) {
      final address = {
        'userId': data['userId'],
        'phone': phoneController.text,
        'address': detailController.text,
        'wardCode': selectedWardCode,
        'wardName': selectedWardName,
        'districtId': selectedDistrictId,
        'districtName': selectedDistrictName,
        'provinceId': selectedProvinceId,
        'provinceName': selectedProvinceName,
      };
      print("Submitting address: $address");
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<dynamic> items,
    required void Function(String?) onChanged,
    required String displayField,
    required String idField,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      isExpanded: true,
      dropdownColor: Colors.white,
      menuMaxHeight: 200,
      alignment: AlignmentDirectional.bottomStart,
      items: items.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item[idField].toString(),
          child: Text(
            item[displayField],
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Address')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration('Full Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Phone Number'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Province',
                  value: selectedProvinceId,
                  items: provinces,
                  displayField: 'ProvinceName',
                  idField: 'ProvinceID',
                  onChanged: (value) {
                    final selected = provinces.firstWhere(
                        (element) => element['ProvinceID'].toString() == value);
                    setState(() {
                      selectedProvinceId = selected['ProvinceID'].toString();
                      selectedProvinceName = selected['ProvinceName'];
                    });
                    _loadDistricts(selectedProvinceId!);
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'District',
                  value: selectedDistrictId,
                  items: districts,
                  displayField: 'DistrictName',
                  idField: 'DistrictID',
                  onChanged: (value) {
                    final selected = districts.firstWhere(
                        (element) => element['DistrictID'].toString() == value);
                    setState(() {
                      selectedDistrictId = selected['DistrictID'].toString();
                      selectedDistrictName = selected['DistrictName'];
                    });
                    _loadWards(selectedDistrictId!);
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Ward',
                  value: selectedWardCode,
                  items: wards,
                  displayField: 'WardName',
                  idField: 'WardCode',
                  onChanged: (value) {
                    final selected = wards.firstWhere(
                        (element) => element['WardCode'].toString() == value);
                    setState(() {
                      selectedWardCode = selected['WardCode'].toString();
                      selectedWardName = selected['WardName'];
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: detailController,
                  decoration: _inputDecoration('Detail Address'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit Address',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
