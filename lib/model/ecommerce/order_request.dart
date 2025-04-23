import 'package:flutter_social_share/model/ecommerce/cart_response.dart';

class OrderRequest {
  final String customerId;
  final List<CartResponse> items;
  final ShippingInfoRequest shippingInfo;
  final PaymentRequest payment;

  OrderRequest({
    required this.customerId,
    required this.items,
    required this.shippingInfo,
    required this.payment,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(
        customerId: json['customerId'],
        items: (json['items'] as List)
            .map((item) => CartResponse.fromJson(item))
            .toList(),
        shippingInfo: ShippingInfoRequest.fromJson(json['shippingInfo']),
        payment: PaymentRequest.fromJson(json["payment"]));
  }
}

class PaymentRequest {
  final String method;
  final double amountPaid;

  PaymentRequest({
    required this.method,
    required this.amountPaid,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      method: json['method'],
      amountPaid: json['amountPaid'],
    );
  }
}

class ShippingInfoRequest {
  final String receiverName;
  final String receiverPhone;
  final String address;
  final String wardCode;
  final int districtId;
  final int shippingFee;

  ShippingInfoRequest({
    required this.receiverName,
    required this.receiverPhone,
    required this.address,
    required this.wardCode,
    required this.districtId,
    required this.shippingFee,
  });

  factory ShippingInfoRequest.fromJson(Map<String, dynamic> json) {
    return ShippingInfoRequest(
        receiverName: json['receiverName'],
        receiverPhone: json['receiverPhone'],
        address: json['address'],
        wardCode: json['wardCode'],
        districtId: json['districtId'],
        shippingFee: json['shippingFee']);
  }
}
