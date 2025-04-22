import '../user.dart';


class Address {
  final String id;
  final User user;
  final String phone;
  final String address;
  final String wardCode;
  final String wardName;
  final int districtId;
  final String districtName;
  final int provinceId;
  final String provinceName;
  final bool isDefault;

  Address({
    required this.id,
    required this.user,
    required this.phone,
    required this.address,
    required this.wardCode,
    required this.wardName,
    required this.districtId,
    required this.districtName,
    required this.provinceId,
    required this.provinceName,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      user: User.fromJson(json['user']),
      phone: json['phone'],
      address: json['address'],
      wardCode: json['wardCode'],
      wardName: json['wardName'],
      districtId: json['districtId'],
      districtName: json['districtName'],
      provinceId: json['provinceId'],
      provinceName: json['provinceName'],
      isDefault: json['isDefault'],
    );
  }
}