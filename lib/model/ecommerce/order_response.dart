import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/model/ecommerce/line_item_response.dart';
import 'package:flutter_social_share/model/ecommerce/payment_response.dart';
import 'package:flutter_social_share/model/ecommerce/shipping_info_response.dart';

import '../user.dart';

class OrderResponse {
  final String id;
  final String orderCode;
  final String status;
  final double totalAmount;
  final double shippingFee;
  final User customer;
  final List<LineItemResponse> items;
  final ShippingInfoResponse? shippingInfo;
  final PaymentResponse? payment;
  final String createdAt;
  final String updatedAt;

  OrderResponse({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.totalAmount,
    required this.shippingFee,
    required this.customer,
    required this.items,
    this.shippingInfo,
    this.payment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'] ?? '',
      orderCode: json['orderCode'] ?? '',
      status: json['status'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      shippingFee: (json['shippingFee'] ?? 0).toDouble(),
      customer: User.fromJson(json['customer']),
      items: (json['items'] as List<dynamic>)
          .map((item) => LineItemResponse.fromJson(item))
          .toList(),
      shippingInfo: json['shippingInfo'] != null
          ? ShippingInfoResponse.fromJson(json['shippingInfo'])
          : null,
      payment: json['payment'] != null
          ? PaymentResponse.fromJson(json['payment'])
          : null,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}




