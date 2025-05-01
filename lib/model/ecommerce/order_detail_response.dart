import 'package:flutter_social_share/model/ecommerce/line_item_response.dart';
import 'package:flutter_social_share/model/ecommerce/payment_response.dart';
import 'package:flutter_social_share/model/ecommerce/shipping_info_response.dart';
import 'package:flutter_social_share/model/user.dart';

class OrderDetailResponse {
  final String id;
  final String orderCode;
  final String createdAt;
  final String updatedAt;
  final Customer customer;
  final List<Item> items;
  final String status;
  final ShippingInfoResponse shippingInfo;
  final PaymentResponse payment;
  final double totalAmount;
  final double shippingFee;

  OrderDetailResponse({
    required this.id,
    required this.orderCode,
    required this.createdAt,
    required this.updatedAt,
    required this.customer,
    required this.items,
    required this.status,
    required this.shippingInfo,
    required this.payment,
    required this.totalAmount,
    required this.shippingFee,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      id: json['id'],
      orderCode: json['orderCode'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      customer: Customer.fromJson(json['customer']),
      items: (json['items'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList(),
      status: json['status'],
      shippingInfo: ShippingInfoResponse.fromJson(json['shippingInfo']),
      payment: PaymentResponse.fromJson(json['payment']),
      totalAmount: json['totalAmount'],
      shippingFee: json['shippingFee'],
    );
  }
}

class Customer {
  final String id;
  final String username;
  final String email;
  final String password;
  final List<Role> roles;
  final String cover;
  final String avatar;
  final String firstName;
  final String lastName;
  final String bio;
  final String websiteUrl;
  final int followerCount;
  final int friendsCount;
  final int postCount;
  final String status;
  final String fullName;
  final String createdAt;
  final String updatedAt;

  Customer({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.roles,
    required this.cover,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.websiteUrl,
    required this.followerCount,
    required this.friendsCount,
    required this.postCount,
    required this.status,
    required this.fullName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      roles:
          (json['roles'] as List).map((role) => Role.fromJson(role)).toList(),
      cover: json['cover'],
      avatar: json['avatar'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'],
      websiteUrl: json['websiteUrl'],
      followerCount: json['followerCount'],
      friendsCount: json['friendsCount'],
      postCount: json['postCount'],
      status: json['status'],
      fullName: json['fullName'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Role {
  final String id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Item {
  final String id;
  final String createdAt;
  final String updatedAt;
  final Product product;
  final int quantity;
  final num price;
  final num total;

  Item(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.product,
      required this.quantity,
      required this.price,
      required this.total});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      price: json['price'],
      total: json['quantity'],
    );
  }
}

class Product {
  final String createdAt;
  final String updatedAt;
  final String id;
  final String name;
  final String description;
  final double price;
  final double weight;
  final double width;
  final double height;
  final double length;
  final Category category;
  final List<ProductImage> images;

  final int stockQuantity;
  final String currency;
  final double rating;
  final int salesCount;
  final bool visible;
  final bool deleted;
  final bool liked;

  Product({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.width,
    required this.height,
    required this.length,
    required this.category,
    required this.images,
    required this.stockQuantity,
    required this.currency,
    required this.rating,
    required this.salesCount,
    required this.visible,
    required this.deleted,
    required this.liked,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      weight: json['weight'],
      width: json['width'],
      height: json['height'],
      length: json['length'],
      category: Category.fromJson(json['category']),
      images: (json['images'] as List)
          .map((img) => ProductImage.fromJson(img))
          .toList(),
      stockQuantity: json['stockQuantity'],
      currency: json['currency'],
      rating: json['rating'],
      salesCount: json['salesCount'],
      visible: json['visible'],
      deleted: json['deleted'],
      liked: json['liked'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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
  final Customer author;
  final String status;

  ProductImage({
    required this.id,
    required this.filename,
    required this.contentType,
    required this.fileSize,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      id: json['id'],
      filename: json['filename'],
      contentType: json['contentType'],
      fileSize: json['fileSize'],
      author: Customer.fromJson(json['author']),
      status: json['status'],
    );
  }
}
