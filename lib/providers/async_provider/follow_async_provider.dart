import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/follow_response.dart';
import 'package:flutter_social_share/providers/state_provider/follow_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';

final followAsyncNotifierProvider =
    AsyncNotifierProvider<FollowNotifier, List<FollowUserResponse>>(
        FollowNotifier.new);

class FollowNotifier extends AsyncNotifier<List<FollowUserResponse>> {
  @override
  Future<List<FollowUserResponse>> build() async {
    return []; // Nothing is fetched automatically
  }

  Future<void> follow(String userId) async {
    final followService = ref.watch(followServiceProvider);
    await followService.follow(userId);
    final followers = await followService.getFollowers(userId);
    state = AsyncData(followers);
  }

  Future<void> unfollow(String userId) async {
    final followService = ref.watch(followServiceProvider);
    await followService.unfollow(userId);
    final followers = await followService.getFollowers(userId);
    state = AsyncData(followers);
  }

  Future<void> getFollowers(String userId) async {
    final followService = ref.watch(followServiceProvider);
    final followers = await followService.getFollowers(userId);
    state = AsyncData(followers);
  }

  Future<void> getFollowings(String userId) async {
    final followService = ref.watch(followServiceProvider);
    final followings = await followService.getFollowings(userId);
    state = AsyncData(followings);
  }
}
