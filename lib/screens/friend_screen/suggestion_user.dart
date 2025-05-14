import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/follower_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/friend_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/user_async_provider.dart';
import 'package:flutter_social_share/screens/friend_screen/widgets/list_user.dart';
import 'package:flutter_social_share/utils/uidata.dart';

import '../../providers/async_provider/following_async_provider.dart';
import '../../providers/state_provider/auth_provider.dart';

class SuggestionUser extends ConsumerStatefulWidget {
  const SuggestionUser({super.key});

  @override
  ConsumerState<SuggestionUser> createState() => _SuggestionUserState();
}

class _SuggestionUserState extends ConsumerState<SuggestionUser> {
  String? requesterId;

  @override
  void initState() {
    super.initState();
    fetchAllUser();
  }

  Future<void> fetchAllUser() async {
    await ref.read(userAsyncNotifierProvider.notifier).getSuggestedUsers();
  }

  void sendFriendRequest(String userId) async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    requesterId = data['userId'];
    await ref
        .read(friendAsyncNotifierProvider.notifier)
        .addFriend(requesterId!, userId);
    fetchAllUser();
  }

  void followRequest(String userId) async {
    await ref.read(followingAsyncNotifierProvider.notifier).follow(userId);
    fetchAllUser();
  }

  @override
  Widget build(BuildContext context) {
    final allUsersState = ref.watch(userAsyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('People You May Know'),
        backgroundColor: Colors.white,
      ),
      body: allUsersState.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No users to suggest.'));
          }

          return Padding(
            padding: const EdgeInsets.all(8), // 👈 Add padding here
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => const Divider(height: 10),
              itemBuilder: (context, index) {
                final user = users[index];

                return ListUser(
                  userId: user.id,
                  username: user.username,
                  avatar: user.avatar,
                  trailing: Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () => sendFriendRequest(user.id),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.person_add_alt_1,
                            color: Colors.white),
                        label: const Text(
                          "Add Friend",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => followRequest(user.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Follow",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
