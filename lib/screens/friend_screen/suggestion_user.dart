import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/friend_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/user_async_provider.dart';
import 'package:flutter_social_share/screens/friend_screen/widgets/list_user.dart';
import 'package:flutter_social_share/utils/uidata.dart';

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
    print("Friend request sent to user: $userId");
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    requesterId = data['userId'];
    print(userId);
    print(requesterId);
    await ref
        .read(friendAsyncNotifierProvider.notifier)
        .addFriend(userId,requesterId!);
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
                  trailing: ElevatedButton(
                    onPressed: () => sendFriendRequest(user.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Request Friend",
                      style: TextStyle(color: Colors.white),
                    ),
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
