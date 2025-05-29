import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/social/friend_connection.dart';
import '../state_provider/chat_provider.dart';

final friendConnectionAsyncNotifierProvider =
    AsyncNotifierProvider<FriendConnectionNotifier, List<FriendConnection>>(
        FriendConnectionNotifier.new);

class FriendConnectionNotifier extends AsyncNotifier<List<FriendConnection>> {
  @override
  Future<List<FriendConnection>> build() async {
    final chatService = ref.watch(chatServiceProvider);
    final listFriendConnection = await chatService.getFriends();
    return listFriendConnection;
  }
}
