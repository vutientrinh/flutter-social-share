import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/follow_response.dart';
import 'package:flutter_social_share/providers/state_provider/follow_provider.dart';
import '../state_provider/auth_provider.dart';

final followingAsyncNotifierProvider =
AsyncNotifierProvider<FollowingNotifier, List<FollowUserResponse>>(
    FollowingNotifier.new);

class FollowingNotifier extends AsyncNotifier<List<FollowUserResponse>> {
  @override
  Future<List<FollowUserResponse>> build() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    return await getFollowings(data['userId']);
  }
  Future<List<FollowUserResponse>> getFollowings(String userId) async {
    final followService = ref.watch(followServiceProvider);
    print("get dc ròi nè chaaaaa");
    final followings = await followService.getFollowings(userId);
    return followings;
  }
  Future<void> unfollow(String userId) async {
    final followService = ref.watch(followServiceProvider);
    await followService.unfollow(userId);
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final followings =  await getFollowings(data['userId']);
    state = AsyncData(followings);
  }
  Future<void> follow(String userId) async {
    final followService = ref.watch(followServiceProvider);
    await followService.follow(userId);
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final followings =  await getFollowings(data['userId']);
    state = AsyncData(followings);
  }
}