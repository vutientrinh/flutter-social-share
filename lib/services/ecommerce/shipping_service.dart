import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingService {
  final Dio dio;

  ShippingService(this.dio);

  Future<Response> getProvinces() async {
    return dio.get('/master-data/province');
  }

  Future<Response> getDistricts(String provinceId) async {
    return dio.get(
      '/master-data/district',
      queryParameters: {'province_id': provinceId},
    );
  }

  Future<Response> getWards(String districtId) async {
    return dio.get(
      '/master-data/ward',
      queryParameters: {'district_id': districtId},
    );
  }

  Future<void> getShippingFee() async {}
}
