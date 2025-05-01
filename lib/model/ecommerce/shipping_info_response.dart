class ShippingInfoResponse {
  final String ghnOrderCode;
  final String receiverName;
  final String receiverPhone;
  final String address;
  final String wardCode;
  final int districtId;
  final String serviceId;
  final String serviceTypeId;
  final String weight;
  final String shippingStatus;
  final String estimateDeliveryDate;

  ShippingInfoResponse({
    required this.ghnOrderCode,
    required this.receiverName,
    required this.receiverPhone,
    required this.address,
    required this.wardCode,
    required this.districtId,
    required this.serviceId,
    required this.serviceTypeId,
    required this.weight,
    required this.shippingStatus,
    required this.estimateDeliveryDate,
  });

  factory ShippingInfoResponse.fromJson(Map<String, dynamic> json) {
    return ShippingInfoResponse(
      ghnOrderCode: json['ghnOrderCode'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverPhone: json['receiverPhone'] ?? '',
      address: json['address'] ?? '',
      wardCode: json['wardCode'] ?? '',
      districtId: json['districtId'] ?? 0,
      serviceId: json['serviceId'] ?? '',
      serviceTypeId: json['serviceTypeId'] ?? '',
      weight: json['weight'] ?? '',
      shippingStatus: json['shippingStatus'] ?? '',
      estimateDeliveryDate: json['estimateDeliveryDate'] ?? '',
    );
  }
}