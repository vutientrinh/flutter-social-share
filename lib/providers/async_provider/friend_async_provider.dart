import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/follow_response.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';

import '../../model/social/friend_request.dart';
import '../state_provider/auth_provider.dart';

final friendAsyncNotifierProvider =
AsyncNotifierProvider<FriendNotifier, List<User>>(FriendNotifier.new);

class FriendNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    return getFriend(data['userId']); // Nothing is fetched automatically
  }

  Future<List<User>> getFriend ( String userId ) async{
    final friendService = ref.watch(friendServiceProvider);
    final listFriends = await friendService.getFriends(userId);
    return listFriends;
  }
  Future<void> acceptFriend(String requestId) async {
    final friendService = ref.watch(friendServiceProvider);
    await friendService.acceptFriend(requestId);

    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final userId = data['userId'];

    final listFriendUpdate = await getFriend(userId);
    state = AsyncData(listFriendUpdate);
  }
  Future<void> removeFriend(String requestId) async {
    final friendService = ref.watch(friendServiceProvider);
    await friendService.deleteFriend(requestId);

    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final userId = data['userId'];

    final listFriendUpdate = await getFriend(userId);
    state = AsyncData(listFriendUpdate);
  }
  Future<void> addFriend(String requesterId, String receiverId ) async {
    final friendService = ref.watch(friendServiceProvider);
    await friendService.addFriend(requesterId,receiverId);

    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final userId = data['userId'];

    final listFriendUpdate = await getFriend(userId);
    state = AsyncData(listFriendUpdate);
  }

}