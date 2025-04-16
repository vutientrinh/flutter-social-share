import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/friend_request_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';
import 'package:flutter_social_share/screens/friend_screen/user_avatar.dart';
import '../../model/user.dart';
import '../../providers/async_provider/friend_async_provider.dart';
import '../../providers/state_provider/auth_provider.dart';
import 'list_user.dart';

class FriendsTab extends ConsumerStatefulWidget {
  const FriendsTab({super.key});

  @override
  ConsumerState<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends ConsumerState<FriendsTab> {
  String? userId;

  @override
  void initState() {
    super.initState();
    getFriendRequest();
  }

  Future<void> getFriendRequest() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    userId = data['userId'];
    print(userId);
    if (userId != null) {
      await ref
          .read(friendRequestAsyncProvider.notifier)
          .getFriendRequests(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendState = ref.watch(friendRequestAsyncProvider);
    return Column(

      children: [
        // Top title button
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.people_alt),
              SizedBox(width: 8),
              Text(
                "Friend Requests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: friendState.when(
            data: (friendRequests) {
              if (friendRequests.isEmpty) {
                return const Center(child: Text('No users found.'));
              }
              return ListView.builder(
                itemCount: friendRequests.length,
                itemBuilder: (context, index) {
                  final friendRequest = friendRequests[index];
                  return ListUser(
                    username: friendRequest.username ?? "Unknown",
                    avatar: friendRequest.avatar ?? "",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => ref
                              .read(friendAsyncNotifierProvider.notifier)
                              .acceptFriend(friendRequest.id),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text("Accept"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () => ref
                              .read(friendAsyncNotifierProvider.notifier)
                              .removeFriend(friendRequest.id),
                          child: const Text("Deny"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        )
      ],
    );
  }
}
