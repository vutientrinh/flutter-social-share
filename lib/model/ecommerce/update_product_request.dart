import 'category.dart';

class UpdateProductRequest {
  final String name;
  final String description;
  final int price;
  final int weight;
  final int width;
  final int height;
  final int length;
  final String categoryId;
  final int stockQuantity;


  UpdateProductRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.width,
    required this.height,
    required this.length,
    required this.categoryId,
    required this.stockQuantity,

  });

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProductRequest(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      weight: json['weight'],
      width: json['width'],
      height: json['height'],
      length: json['length'],
      categoryId: json['categoryId'],
      stockQuantity: json['stockQuantity'],

    );
  }
}