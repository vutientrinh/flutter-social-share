import 'package:flutter_social_share/model/ecommerce/cart_response.dart';

class OrderRequest {
  final String customerId;
  final List<ProductRequest> items;
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
          .map((item) => ProductRequest.fromJson(item))
          .toList(),
      shippingInfo: ShippingInfoRequest.fromJson(json['shippingInfo']),
      payment: PaymentRequest.fromJson(json['payment']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'items': items.map((e) => e.toJson()).toList(),
      'shippingInfo': shippingInfo.toJson(),
      'payment': payment.toJson(),
    };
  }
}


class ProductRequest {
  final String productId;
  final double price;
  final int quantity;

  ProductRequest({
    required this.productId,
    required this.price,
    required this.quantity,
  });

  factory ProductRequest.fromJson(Map<String, dynamic> json) {
    return ProductRequest(
      productId: json['productId'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'price': price,
      'quantity': quantity,
    };
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
  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'amountPaid': amountPaid,
    };
  }
}

class ShippingInfoRequest {
  final String receiverName;
  final String receiverPhone;
  final String address;
  final String wardCode;
  final int districtId;
  final double shippingFee;
  final int serviceId;
  final int serviceTypeId;
  final int weight;

  ShippingInfoRequest({
    required this.receiverName,
    required this.receiverPhone,
    required this.address,
    required this.wardCode,
    required this.districtId,
    required this.shippingFee,
    required this.serviceId,
    required this.serviceTypeId,
    required this.weight,
  });

  factory ShippingInfoRequest.fromJson(Map<String, dynamic> json) {
    return ShippingInfoRequest(
      receiverName: json['receiverName'],
      receiverPhone: json['receiverPhone'],
      address: json['address'],
      wardCode: json['wardCode'],
      districtId: json['districtId'],
      shippingFee: json['shippingFee'].toDouble(),
      serviceId: json['serviceId'],
      serviceTypeId: json['serviceTypeId'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'address': address,
      'wardCode': wardCode,
      'districtId': districtId,
      'shippingFee': shippingFee,
      'serviceId': serviceId,
      'serviceTypeId': serviceTypeId,
      'weight': weight,
    };
  }
}
