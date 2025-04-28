import 'package:dio/dio.dart';

import '../../model/ecommerce/category.dart';

class CategoryService {
  final Dio _dio;

  CategoryService(this._dio);

  Future<void> createCategory({
    required String name,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        '/api/categories/create',
        data: {
          'name': name,
          'description': description,
        },
      );
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  Future<Category> updateCategory({
    required String id,
    required String name,
    required String description,
  }) async {
    try {
      final response = await _dio.put(
        '/api/categories/$id/update',
        data: {
          'name': name,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        return Category.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update category');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await _dio.delete('/api/categories/$id/delete');
      if (response.statusCode == 200) {
        return response.data['data'] == true;
      } else {
        throw Exception('Failed to delete category');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  Future<Category> getCategoryById(String id) async {
    try {
      final response = await _dio.get('/api/categories/$id');
      if (response.statusCode == 200) {
        return Category.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch category');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _dio.get('/api/categories/all');
      if (response.statusCode == 200) {
        List<Category> categories = (response.data['data'] as List)
            .map((json) => Category.fromJson(json))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }
}
