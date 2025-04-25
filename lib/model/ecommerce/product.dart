import 'category.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final Category category;
  final num price;
  final num weight;
  final num width;
  final num height;
  final num length;
  final List<String> images;
  final int stockQuantity;
  final String currency;
  final num rating;
  final int salesCount;
  final bool visible;
  final bool isDeleted;
  final bool isLiked;
  final int amountRating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.weight,
    required this.width,
    required this.height,
    required this.length,
    required this.images,
    required this.stockQuantity,
    required this.currency,
    required this.rating,
    required this.salesCount,
    required this.visible,
    required this.isDeleted,
    required this.isLiked,
    required this.amountRating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      price: json['price'],
      weight: json['weight'],
      width: json['width'],
      height: json['height'],
      length: json['length'],
      images: List<String>.from(json['images']),
      stockQuantity: json['stockQuantity'],
      currency: json['currency'],
      rating: (json['rating'] as num).toDouble(),
      salesCount: json['salesCount'],
      visible: json['visible'],
      isDeleted: json['isDeleted'],
      isLiked: json['isLiked'],
      amountRating: json['amountRating'],
    );
  }
}