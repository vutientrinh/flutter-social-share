import 'package:flutter_social_share/model/ecommerce/product.dart';

class  CartResponse {
  final Product product;
  final num price;
  final int quantity;

  CartResponse({
    required this.product,
    required this.price,
    required this.quantity,

  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      product: Product.fromJson(json['product']),
      price: json['price'],
      quantity: json['quantity']
    );
  }
}