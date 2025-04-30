import 'package:flutter_social_share/model/ecommerce/line_item_response.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';
import 'package:flutter_social_share/model/user.dart';

class OrderDetailResponse {
  final String id;
  final String orderCode;
  final String createdAt;
  final String updatedAt;
  final User customer;
  final List<LineItemResponse> items;

  OrderDetailResponse({
    required this.id,
    required this.orderCode,
    required this.createdAt,
    required this.updatedAt,
    required this.customer,
    required this.items,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      id: json['id'],
      orderCode: json['orderCode'],
      createdAt: json['createdAt'],
      updatedAt:json['updatedAt'],
      customer: User.fromJson(json['customer']),
      items: List<LineItemResponse>.from(json['items'].map((x) => LineItemResponse.fromJson(x))),
    );
  }
}

