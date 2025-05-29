import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/follow_response.dart';
import 'package:flutter_social_share/providers/state_provider/follow_provider.dart';
import '../state_provider/auth_provider.dart';

final followerAsyncNotifierProvider =
    AsyncNotifierProvider<FollowerNotifier, List<FollowUserResponse>>(
        FollowerNotifier.new);

class FollowerNotifier extends AsyncNotifier<List<FollowUserResponse>> {
  @override
  Future<List<FollowUserResponse>> build() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    return await getFollowers(data['userId']);
  }

  Future<List<FollowUserResponse>> getFollowers(String userId) async {
    final followService = ref.watch(followServiceProvider);
    final followers = await followService.getFollowers(userId);
    return followers;
  }

  Future<void> follow(String userId) async {
    final followService = ref.watch(followServiceProvider);
    await followService.follow(userId);
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final followers = await getFollowers(data['userId']);
    state = AsyncData(followers);
  }
}
