import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/screens/friend_screen/widgets/more_option_bottomsheet.dart';

import '../../providers/async_provider/follow_async_provider.dart';
import '../../providers/state_provider/auth_provider.dart';
import 'widgets/list_user.dart';

class FollowerTab extends ConsumerStatefulWidget {
  const FollowerTab({super.key});

  @override
  ConsumerState<FollowerTab> createState() => _FollowerTabState();
}

class _FollowerTabState extends ConsumerState<FollowerTab> {
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserAndLoadFollowings();
  }

  Future<void> fetchUserAndLoadFollowings() async {
    final authService = ref.read(authServiceProvider);
    final data = await authService.getSavedData();
    userId = data['userId'];

    if (userId != null) {
      await ref
          .read(followAsyncNotifierProvider.notifier)
          .getFollowers(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final followerState = ref.watch(followAsyncNotifierProvider);

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
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Handle follow back action here
                      },
                      child: const Text("Follow Back"),
                    ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => MoreOptionBottomsheet(
                          username: follower.username,
                          avatar: follower.avatar,
                          followAt: follower.followAt,
                          option: "Follower",
                          id: follower.id,
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
