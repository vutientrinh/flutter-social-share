import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';

import '../../model/social/friend_request.dart';
import '../state_provider/auth_provider.dart';

final friendRequestAsyncProvider =
    AsyncNotifierProvider<FriendRequestNotifier, List<FriendRequest>>(
        FriendRequestNotifier.new);

class FriendRequestNotifier extends AsyncNotifier<List<FriendRequest>> {
  @override
  Future<List<FriendRequest>> build() async {
    return [];
  }

  Future<void> getFriendRequests(String userId) async {
    final friendService = ref.watch(friendServiceProvider);
    final friend = await friendService.getFriendRequests(userId);
    state = AsyncData(friend);
  }
  // Future<void> acceptFriend(String requestId) async {
  //   final friendService = ref.watch(friendServiceProvider);
  //   await friendService.acceptFriend(requestId);
  //
  //   final authService = ref.read(authServiceProvider);
  //   final data = await authService.getSavedData();
  //   final userId = data['userId'];
  //
  //   final listFriendUpdate = await getFriend(userId);
  //   state = AsyncData(listFriendUpdate);
  // }
}
