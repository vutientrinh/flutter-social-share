import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/friend_async_provider.dart';
import 'widgets/more_option_bottomsheet.dart';
import '../../providers/state_provider/auth_provider.dart';
import 'widgets/list_user.dart';

class FriendList extends ConsumerStatefulWidget {
  const FriendList({super.key});

  @override
  ConsumerState<FriendList> createState() => _FriendListState();
}

class _FriendListState extends ConsumerState<FriendList> {
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchFriend();
  }

  Future<void> fetchFriend() async {
    final authService = ref.read(authServiceProvider);
    final user = await authService.getSavedData(); // Or your own logic
    setState(() {
      userId = user["userId"];
    });
    if (userId != null) {
      ref.read(friendAsyncNotifierProvider.notifier).getFriend(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendState = ref.watch(friendAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your friends'),
        backgroundColor: Colors.white,
      ),
      body: friendState.when(
        data: (friends) {
          if (friends.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return ListUser(
                        userId: friend.id,
                        username: friend.username ?? "Unknown",
                        avatar: friend.avatar,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => MoreOptionWidget(
                                    username: friend.username,
                                    avatar: friend.avatar,
                                    followAt: "",
                                    option: "Friend",
                                    id: friend.id,
                                    author: userId!,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ))
                ],
              ));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
