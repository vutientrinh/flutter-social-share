import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/friend_request_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/friend_provider.dart';
import 'package:flutter_social_share/route/screen_export.dart';
import 'package:flutter_social_share/screens/friend_screen/widgets/user_avatar.dart';
import '../../model/user.dart';
import '../../providers/async_provider/friend_async_provider.dart';
import '../../providers/state_provider/auth_provider.dart';
import '../../route/route_constants.dart';
import 'widgets/list_user.dart';

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
    if (userId != null) {
      Future.microtask((){
        ref.read(friendRequestAsyncProvider.notifier).getFriendRequests(userId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendState = ref.watch(friendRequestAsyncProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuggestionUser()),
                      )
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                    ),
                    child: const Text(
                      "Suggestions",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16), // 🔧 changed from height to width
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FriendList()),
                      )
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                    ),
                    child: const Text(
                      "Your friends",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // vertical space between button and row
              const Row(
                children: [
                  Icon(Icons.people_alt),
                  SizedBox(width: 10), // horizontal space between icon and text
                  Text(
                    "Friend Requests",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
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
                    userId: friendRequest.id,
                    username: friendRequest.username ?? "Unknown",
                    avatar: friendRequest.avatar ?? "",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async => {
                            await ref
                                .read(friendAsyncNotifierProvider.notifier)
                                .acceptFriend(friendRequest.requestId),
                            getFriendRequest(),
                            ref.invalidate(friendRequestAsyncProvider)
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () async => {
                            await ref
                                .read(friendAsyncNotifierProvider.notifier)
                                .removeFriend(friendRequest.id),
                          },
                          child: const Text(
                            "Deny",
                            style: TextStyle(color: Colors.black),
                          ),
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
