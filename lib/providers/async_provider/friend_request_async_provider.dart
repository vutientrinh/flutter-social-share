import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';

import '../../model/social/friend_request.dart';
import '../state_provider/auth_provider.dart';

final friendRequestAsyncProvider =
AsyncNotifierProvider<FriendRequestNotifier, List<FriendRequest>>(FriendRequestNotifier.new);

class FriendRequestNotifier extends AsyncNotifier<List<FriendRequest>> {
  Future<List<FriendRequest>> build() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final userId = data['userId'];
    if (userId == null) throw Exception("User ID is null");
    final requestFriend = await getFriendRequests(userId);
    return requestFriend;
  }

  Future<List<FriendRequest>> getFriendRequests(String userId) async {
    final friendService = ref.watch(friendServiceProvider);
    return await friendService.getFriendRequests(userId);
  }
}
