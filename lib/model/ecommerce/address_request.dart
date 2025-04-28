class AddressRequest {
  final String userId;
  final String phone;
  final String address;
  final String wardCode;
  final String wardName;
  final int districtId;
  final String districtName;
  final int provinceId;
  final String provinceName;

  AddressRequest({
    required this.userId,
    required this.phone,
    required this.address,
    required this.wardCode,
    required this.wardName,
    required this.districtId,
    required this.districtName,
    required this.provinceId,
    required this.provinceName,
  });

  factory AddressRequest.fromJson(Map<String, dynamic> json) {
    return AddressRequest(
      userId: json['userId'],
      phone: json['phone'],
      address: json['address'],
      wardCode: json['wardCode'],
      wardName: json['wardName'],
      districtId: json['districtId'],
      districtName: json['districtName'],
      provinceId: json['provinceId'],
      provinceName: json['provinceName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'phone': phone,
      'address': address,
      'wardCode': wardCode,
      'wardName': wardName,
      'districtId': districtId,
      'districtName': districtName,
      'provinceId': provinceId,
      'provinceName': provinceName,
    };
  }
}
