import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/follow_response.dart';

import '../../providers/async_provider/follow_async_provider.dart';
import '../../providers/state_provider/auth_provider.dart';
import 'list_user.dart';

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
      await ref.read(followAsyncNotifierProvider.notifier).getFollowers(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final followingState = ref.watch(followAsyncNotifierProvider);

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
              username: following.username ?? "Unknown",
              avatar: following.avatar ?? "",
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!following.hasFollowedBack)
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
                        builder: (context) => _buildBottomSheet(context, following),
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
  Widget _buildBottomSheet(BuildContext context, FollowUserResponse following) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("More options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text("Block"),
          SizedBox(height: 8),
          Text("Report"),
          SizedBox(height: 8),
          Text("Mute"),
        ],
      ),
    );
  }
}