import '../user.dart';

class OrderDetailResponse {
  final String id;
  final String orderCode;
  final User customer;
  final List<LineItemResponse> items;
  final String createdAt;
  final String updatedAt;

  OrderDetailResponse({
    required this.id,
    required this.orderCode,
    required this.customer,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      id: json['id'] ?? '',
      orderCode: json['orderCode'] ?? '',
      customer: User.fromJson(json['customer']),
      items: (json['items'] as List<dynamic>)
          .map((item) => LineItemResponse.fromJson(item))
          .toList(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class LineItemResponse {
  final String id;
  final ProductResponse product;
  final String createdAt;
  final String updatedAt;

  LineItemResponse({
    required this.id,
    required this.product,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LineItemResponse.fromJson(Map<String, dynamic> json) {
    return LineItemResponse(
      id: json['id'] ?? '',
      product: ProductResponse.fromJson(json['product']),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class ProductResponse {
  final String id;
  final String name;
  final String description;
  final CategoryResponse category;
  final double price;
  final double weight;
  final double width;
  final double height;
  final double length;
  final List<ProductImage> images;
  final String createdAt;
  final String updatedAt;

  ProductResponse({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: CategoryResponse.fromJson(json['category']),
      price: (json['price'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      images: (json['images'] as List<dynamic>)
          .map((img) => ProductImage.fromJson(img))
          .toList(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class CategoryResponse {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  CategoryResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class ProductImage {
  final String id;
  final String filename;
  final String contentType;
  final int fileSize;
  final String createdAt;
  final String updatedAt;

  ProductImage({
    required this.id,
    required this.filename,
    required this.contentType,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? '',
      filename: json['filename'] ?? '',
      contentType: json['contentType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
