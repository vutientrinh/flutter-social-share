import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/user.dart';
import 'api_client.dart';

class FriendService {
  final Dio _dio = ApiClient.dio;

  Future<Response> addFriend(String requesterId, String receiverId) async {
    try {
      final response = await _dio.post(
        '/users/create-request',
        data: {
          'requesterId': requesterId,
          'receiverId': receiverId,
        },
      );
      return response;
    } catch (e) {
      print('Error adding friend: $e');
      throw Exception('Failed to add friend: $e');
    }
  }

  Future<Response> acceptFriend(String friendRequestId) async {
    try {
      return await _dio.post('/users/$friendRequestId/accept-friend');
    } catch (e) {
      print('Error accepting friend: $e');
      throw Exception('Failed to accept friend: $e');
    }
  }

  Future<Response> deleteFriend(String friendRequestId) async {
    try {
      return await _dio.delete('/users/$friendRequestId/delete-friend');
    } catch (e) {
      print('Error deleting friend: $e');
      throw Exception('Failed to delete friend: $e');
    }
  }

  Future<Response> getFriends(String userId, {int page = 1, int size = 10}) async {
    try {
      return await _dio.get(
        '/users/$userId/get-friends',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
    } catch (e) {
      print('Error getting friends: $e');
      throw Exception('Failed to get friends: $e');
    }
  }

  Future<List<User>> getFriendRequests(String userId, {int page = 1, int size = 10}) async {
    try {
      final response =  await _dio.get(
        '/users/$userId/get-friends-request',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      final List<dynamic> userListJson = response.data['data']['data'];
      return userListJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error getting friend requests: $e');
      throw Exception('Failed to get friend requests: $e');
    }
  }
}

