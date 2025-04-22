import 'package:flutter_social_share/model/ecommerce/cart_response.dart';
import 'package:flutter_social_share/model/ecommerce/payment_request.dart';

import 'shipping_info.dart';

class OrderRequest {
  final String customerId;
  final List<CartResponse> items;
  final ShippingInfo shippingInfo;
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
        shippingInfo: ShippingInfo.fromJson(json['shippingInfo']),
        payment: PaymentRequest.fromJson(json["payment"]));
  }
}
