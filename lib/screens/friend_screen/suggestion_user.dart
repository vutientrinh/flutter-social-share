import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/follower_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/friend_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/user_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/follow_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_social_share/utils/uidata.dart';

import '../../model/social/follow_response.dart';
import '../../providers/async_provider/following_async_provider.dart';
import '../../providers/state_provider/auth_provider.dart';
import '../profile_screen/profile_screen.dart';

class SuggestionUser extends ConsumerStatefulWidget {
  const SuggestionUser({super.key});

  @override
  ConsumerState<SuggestionUser> createState() => _SuggestionUserState();
}

class _SuggestionUserState extends ConsumerState<SuggestionUser> {
  String? requesterId;
  List<FollowUserResponse>? listFollowings;

  @override
  void initState() {
    super.initState();
    fetchAllUser();
  }

  Future<void> fetchAllUser() async {
    await ref.read(userAsyncNotifierProvider.notifier).getSuggestedUsers();
    getFollowingList();
  }

  void getFollowingList() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    final response =
        await ref.read(followServiceProvider).getFollowings(data['userId']);
    setState(() {
      listFollowings = response;
    });
  }

  void sendFriendRequest(String userId) async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    requesterId = data['userId'];
    await ref
        .read(friendAsyncNotifierProvider.notifier)
        .addFriend(requesterId!, userId);
    await Flushbar(
      titleText: const Text(
        'Success',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        'Send friend request successfully!',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      backgroundColor: Colors.green.shade600,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: BorderRadius.circular(12),
      boxShadows: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 8,
        ),
      ],
      animationDuration: const Duration(milliseconds: 200),
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 28,
      ),
    ).show(context);

    fetchAllUser();
  }

  void followRequest(String userId) async {
    await ref.read(followingAsyncNotifierProvider.notifier).follow(userId);
    await Flushbar(
      titleText: const Text(
        'Success',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        'Follow successfully!',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      backgroundColor: Colors.green.shade600,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: BorderRadius.circular(12),
      boxShadows: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 8,
        ),
      ],
      animationDuration: const Duration(milliseconds: 200),
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 28,
      ),
    ).show(context);
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
                final isFollowing =
                    listFollowings?.any((f) => f.id == user.id) ?? false;
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: user.id),
                      ),
                    )
                  },
                  child:
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              LINK_IMAGE.publicImage(user.avatar),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username
                                Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Row buttons
                                Row(
                                  children: [
                                    FilledButton.icon(
                                      onPressed: () => sendFriendRequest(user.id),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
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
                                    const SizedBox(width: 10),
                                    isFollowing
                                        ? const Text(
                                            "Following",
                                            style: TextStyle(color: Colors.grey),
                                          )
                                        : ElevatedButton(
                                            onPressed: () => followRequest(user.id),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              "Follow",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
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
