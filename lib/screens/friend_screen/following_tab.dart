import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/following_async_provider.dart';
import 'package:flutter_social_share/screens/friend_screen/widgets/more_option_bottomsheet.dart';
import 'package:flutter_social_share/model/social/follow_response.dart';
import 'package:flutter_social_share/providers/async_provider/follower_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import '../../providers/state_provider/follow_provider.dart';
import 'widgets/list_user.dart';

class FollowingTab extends ConsumerStatefulWidget {
  const FollowingTab({super.key});

  @override
  ConsumerState<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends ConsumerState<FollowingTab> {
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
    setState(() {
      userId = userId;
    });
    if (userId != null) {
      Future.microtask(() {
        ref
            .read(followingAsyncNotifierProvider.notifier)
            .getFollowings(userId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final followingState = ref.watch(followingAsyncNotifierProvider);

    return followingState.when(
      data: (followings) {
        if (followings.isEmpty) {
          return const Center(child: Text('No users found.'));
        }
        return ListView.builder(
          itemCount: followings.length,
          itemBuilder: (context, index) {
            final following = followings[index];
            return ListUser(
              userId: following.id,
              username: following.username ?? "Unknown",
              avatar: following.avatar ?? "",
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => MoreOptionWidget(
                      username: following.username,
                      avatar: following.avatar ?? "",
                      followAt: following.followAt,
                      option: "Following",
                      id: following.id,
                      author: userId!,
                    ),
                  );
                  fetchUserAndLoadFollowings();
                },
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
