import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/model/ecommerce/line_item_response.dart';

import '../user.dart';

class OrderResponse {
  final String id;
  final String orderCode;
  final String status;
  final int totalAmount;
  final int shippingFee;
  final User customer;
  final List<LineItemResponse> items;
  final ShippingInfoResponse shippingInfo;
  final PaymentResponse payment;
  final String createAt;
  final String updateAt;

  OrderResponse({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.totalAmount,
    required this.shippingFee,
    required this.customer,
    required this.items,
    required this.shippingInfo,
    required this.payment,
    required this.createAt,
    required this.updateAt,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
        id: json['id'],
        orderCode: json['orderCode'],
        status: json['status'],
        totalAmount: json['totalAmount'],
        shippingFee: json['shippingFee'],
        customer: User.fromJson(json['customer']),
        items: (json['items'] as List)
            .map((item) => LineItemResponse.fromJson(item))
            .toList(),
        shippingInfo: ShippingInfoResponse.fromJson(json['shippingInfo']),
        payment: PaymentResponse.fromJson(json["payment"]),
        createAt: json['createAt'],
        updateAt: json['updateAt']);
  }
}

class PaymentResponse {
  final String createAt;
  final String updatedAt;
  final String id;
  final String method;
  final String status;
  final bool transactionId;
  final double amountPaid;

  PaymentResponse({
    required this.createAt,
    required this.updatedAt,
    required this.id,
    required this.method,
    required this.status,
    required this.transactionId,
    required this.amountPaid,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      createAt: json['createAt'],
      updatedAt: json['updateAt'],
      id: json['id'],
      method: json['method'],
      status: json['status'],
      transactionId: json['transactionId'] as bool,
      amountPaid: json['amountPaid'],
    );
  }
}

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
      ghnOrderCode: json['ghnOrderCode'],
      receiverName: json['receiverName'],
      receiverPhone: json['receiverPhone'],
      address: json['address'],
      wardCode: json['wardCode'],
      districtId: json['districtId'],
      serviceId: json['serviceId'],
      serviceTypeId: json['serviceTypeId'],
      weight: json['weight'],
      shippingStatus: json['shippingStatus'],
      estimateDeliveryDate: json['estimateDeliveryDate'],
    );
  }
}
