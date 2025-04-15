import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';

final userAsyncNotifierProvider =
    AsyncNotifierProvider<UserNotifier, List<User>>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    return []; // Nothing is fetched automatically
  }

  Future<void> getAllUsers() async {
    final userService = ref.watch(userServiceProvider);
    final users = await userService.getAllUsers();
    state = AsyncData(users); // this will update the UI
  }
  Future<bool> follow(String userId) async {
    final userService = ref.watch(userServiceProvider);
    final follow = await userService.follow(userId);
    return follow.data;
  }
  Future<bool> unfollow(String userId) async {
    final userService = ref.watch(userServiceProvider);
    final unfollow = await userService.unfollow(userId);
   return unfollow.data; // this will update the UI
  }
  Future<User> getProfileById(String userId) async {
    final userService = ref.watch(userServiceProvider);
    final profile = await userService.getProfileById(userId);
    return profile;
  }
  Future<void> getFollowers(String userId) async {
    final userService = ref.watch(userServiceProvider);
    final follower = await userService.getFollowers(userId);
    return follower.data;
  }
  Future<void> getFollowings(String userId) async {
    final userService = ref.watch(userServiceProvider);
    final follower = await userService.getFollowings(userId);
    return follower.data;
  }

}
