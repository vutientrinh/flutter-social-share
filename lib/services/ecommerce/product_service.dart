import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/ecommerce/product.dart';

import '../../model/ecommerce/update_product_request.dart';

class ProductService {
  final Dio _dio;

  ProductService(this._dio);

  Future<Product> createProduct({
    required String name,
    required String description,
    double? price,
    double? weight,
    double? width,
    double? height,
    double? length,
    required String categoryId,
    int? stockQuantity,
    List<File>? images,
  }) async {
    try {
      List<MultipartFile> multipartImages = [];
      if (images != null && images.isNotEmpty) {
        for (var file in images) {
          final fileName = file.path.split('/').last;
          multipartImages
              .add(await MultipartFile.fromFile(file.path, filename: fileName));
        }
      }

      FormData formData = FormData.fromMap({
        'name': name,
        'description': description,
        if (price != null) 'price': price.toString(),
        if (weight != null) 'weight': weight.toString(),
        if (width != null) 'width': width.toString(),
        if (height != null) 'height': height.toString(),
        if (length != null) 'length': length.toString(),
        'categoryId': categoryId,
        if (stockQuantity != null) 'stockQuantity': stockQuantity.toString(),
        if (multipartImages.isNotEmpty) 'images': multipartImages,
      });

      final response = await _dio.post(
        '/api/products/create',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<List<Product>> getAllProduct(
      {int page = 1,
      int size = 10,
      String? search,
      String? category,
      String? minPrice,
      String? maxPrice,
      num? rating,
      String? inStock,
      String? field,
      String? direction}) async {
    try {
      final response = await _dio.get(
        '/api/products/all',
        queryParameters: {
          'page': page,
          'size': size,
          if (search != null && search.isNotEmpty) 'search': search,
          if (category != null && category.isNotEmpty) 'category': category,
          if (minPrice != null) 'minPrice': minPrice,
          if (maxPrice != null) 'maxPrice': maxPrice,
          if (rating != null) 'rating': rating,
          if (inStock != null) 'inStock': inStock,
          if (field != null) 'field': field,
          if (direction != null) 'direction': direction,
        },
      ); // Adjust according to your backend endpoint
      if (response.statusCode == 200) {
        // Access 'data' field and cast it as a List of user objects
        List<Product> products = (response.data['data']
                as List) // Ensure 'data' is treated as a List
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
  Future<List<Product>> getRecProduct({
    int? page = 1,
    int? size = 10,

  }) async {
    try {
      // ✅ Build query parameters
      final queryParams = {
        'page': page,
        'size': size,
      };

      final response =
      await _dio.get('/api/rec/rec-products', queryParameters: queryParams);

      // ✅ Extract the nested list
      if (response.statusCode == 200) {
        // Access 'data' field and cast it as a List of user objects
        List<Product> products = (response.data['data']
        as List) // Ensure 'data' is treated as a List
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get('/api/products/$id');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch product');
      }
    } catch (e) {
      throw Exception('Error getting product: $e');
    }
  }

  Future<Product> updateProduct(String id, UpdateProductRequest request) async {
    try {
      final response = await _dio.put(
        '/api/products/$id/update',
        data: request,
      );
      if (response.statusCode == 200) {
        return Product.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await _dio.delete('/api/products/$id/delete');
      if (response.statusCode == 200) {
        return response.data['data'] == true;
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
