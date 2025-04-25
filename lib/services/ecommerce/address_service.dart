import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/address.dart';
import 'package:flutter_social_share/model/ecommerce/address_request.dart';

class AddressService {
  final Dio _dio;

  AddressService(this._dio);

  // Create Address
  Future<Address> createAddress(AddressRequest request) async {
    try {
      final response = await _dio.post(
        '/api/address/create',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Address.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create address');
      }
    } catch (e) {
      throw Exception('Error creating address: $e');
    }
  }

  // Get All Addresses (Paginated)
  Future<List<Address>> getAllAddresses({int page = 1, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/api/address/all',
        queryParameters: {'page': page, 'size': size},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['data']['data'];
        print("address : ${data}");
        return data.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch addresses');
      }
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }

  // Update Address
  Future<Address> updateAddress(String id, AddressRequest request) async {
    try {
      final response = await _dio.put(
        '/api/address/update/$id',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Address.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update address');
      }
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  // Delete Address
  Future<bool> deleteAddress(String id) async {
    try {
      final response = await _dio.delete('/api/address/delete/$id');

      if (response.statusCode == 200) {
        return response.data['data'] == true;
      } else {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }

  // Set Default Address
  Future<Address> setDefaultAddress(String id) async {
    try {
      final response = await _dio.post('/api/address/set-default/$id');

      if (response.statusCode == 200) {
        return Address.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to set default address');
      }
    } catch (e) {
      throw Exception('Error setting default address: $e');
    }
  }
}
