class ShippingInfo {
  final String receiverName;
  final String receiverPhone;
  final String address;
  final String wardCode;
  final int districtId;
  final int shippingFee;

  ShippingInfo({
    required this.receiverName,
    required this.receiverPhone,
    required this.address,
    required this.wardCode,
    required this.districtId,
    required this.shippingFee,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) {
    return ShippingInfo(
        receiverName: json['receiverName'],
        receiverPhone: json['receiverPhone'],
        address: json['address'],
        wardCode: json['wardCode'],
        districtId: json['districtId'],
        shippingFee: json['shippingFee']);
  }
}
