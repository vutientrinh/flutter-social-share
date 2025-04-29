import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingService {
  final Dio dio;

  ShippingService(this.dio);

  Future<Response> getProvinces() async {
    return dio.get('/master-data/province');
  }

  Future<Response> getDistricts(int provinceId) async {
    return dio.get(
      '/master-data/district',
      queryParameters: {'province_id': provinceId},
    );
  }

  Future<Response> getWards(int districtId) async {
    return dio.get(
      '/master-data/ward',
      queryParameters: {'district_id': districtId},
    );
  }

  Future<Response> getShippingFee(Map<String, dynamic> request) async {
    return dio.post('/v2/shipping-order/fee', data: request);
  }
}
