import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';

final userAsyncNotifierProvider =
    AsyncNotifierProvider<UserNotifier, List<User>>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    return [];
  }

  Future<void> getAllUsers() async {
    final userService = ref.watch(userServiceProvider);
    final users = await userService.getAllUsers();
    state = AsyncData(users); // this will update the UI
  }
  Future<void> getSuggestedUsers() async {
    final userService = ref.watch(userServiceProvider);
    final users = await userService.getSuggestedUsers();
    state = AsyncData(users); // this will update the UI
  }
}
