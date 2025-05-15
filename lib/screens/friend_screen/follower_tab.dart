import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/screens/friend_screen/widgets/more_option_bottomsheet.dart';

import '../../providers/async_provider/follower_async_provider.dart';
import '../../providers/async_provider/following_async_provider.dart';
import '../../providers/state_provider/auth_provider.dart';
import 'widgets/list_user.dart';

class FollowerTab extends ConsumerStatefulWidget {
  const FollowerTab({super.key});

  @override
  ConsumerState<FollowerTab> createState() => _FollowerTabState();
}

class _FollowerTabState extends ConsumerState<FollowerTab> {
  String? userId;
  String? requesterId;

  @override
  void initState() {
    super.initState();
    fetchUserAndLoadFollower();
  }

  Future<void> fetchUserAndLoadFollower() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    userId = data['userId'];

    if (userId != null) {
      await ref
          .read(followerAsyncNotifierProvider.notifier)
          .getFollowers(userId!);
    }
  }

  void followRequest(String userId) async {
    await ref.read(followerAsyncNotifierProvider.notifier).follow(userId);
    fetchUserAndLoadFollower();
  }

  @override
  Widget build(BuildContext context) {
    final followerState = ref.watch(followerAsyncNotifierProvider);

    return followerState.when(
      data: (followers) {
        if (followers.isEmpty) {
          return const Center(child: Text('No users found.'));
        }
        return ListView.builder(
          itemCount: followers.length,
          itemBuilder: (context, index) {
            final follower = followers[index];
            return ListUser(
              userId: follower.id,
              username: follower.username ?? "Unknown",
              avatar: follower.avatar,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!follower.hasFollowedBack)
                    FilledButton.icon(
                      onPressed: () => followRequest(follower.id),
                      icon: const Icon(Icons.person_add_alt_1,
                          color: Colors.white),
                      label: const Text("Follow Back",
                          style: TextStyle(color: Colors.white)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => MoreOptionWidget(
                          username: follower.username,
                          avatar: follower.avatar ?? "",
                          followAt: follower.followAt,
                          option: "Follower",
                          id: follower.id,
                          author: userId!,
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
