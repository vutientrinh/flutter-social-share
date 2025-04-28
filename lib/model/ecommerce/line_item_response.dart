import 'package:flutter_social_share/model/ecommerce/product.dart';

class LineItemResponse {
  final String id;
  final Product product;
  final int quantity;
  final double price;
  final double total;
  final String createdAt;
  final String updatedAt;

  LineItemResponse({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LineItemResponse.fromJson(Map<String, dynamic> json) {
    return LineItemResponse(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      price: json['price'],
      total: json['total'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
