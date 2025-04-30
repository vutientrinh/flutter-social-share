import 'package:dio/dio.dart';
import 'package:flutter_social_share/model/social/friend_request.dart';
import 'package:flutter_social_share/model/user.dart';

import '../../model/social/follow_response.dart';

class FriendService {
  final Dio _dio;

  FriendService(this._dio);

  Future<Response> addFriend(String requesterId, String receiverId) async {
    try {
      final response = await _dio.post(
        '/api/users/create-request',
        data: {
          'requesterId': requesterId,
          'receiverId': receiverId,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to add friend: $e');
    }
  }

  Future<Response> acceptFriend(String friendRequestId) async {
    try {
      return await _dio.post('/api/users/$friendRequestId/accept-friend');
    } catch (e) {
      throw Exception('Failed to accept friend: $e');
    }
  }

  Future<Response> deleteFriend(String friendRequestId) async {
    try {
      return await _dio.delete('/api/users/$friendRequestId/delete-friend');
    } catch (e) {
      throw Exception('Failed to delete friend: $e');
    }
  }

  Future<List<User>> getFriends(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response =
          await _dio.get('/api/users/$userId/get-friends', queryParameters: {
        'page': page,
        'size': size,
      }, data: {
        "page": page,
        "size": size
      });
      final List<dynamic> friendListJson = response.data['data']['data'];

      return friendListJson.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to delete friends: $e');
    }
  }

  Future<List<FriendRequest>> getFriendRequests(String userId,
      {int page = 1, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/api/users/$userId/get-friends-request',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      final List<dynamic> friendListJson = response.data['data']['data'];
      return friendListJson
          .map((json) => FriendRequest.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get friend requests: $e');
    }
  }
}
