import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/follow_response.dart';
import 'package:flutter_social_share/providers/async_provider/follow_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'list_user.dart';

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

    if (userId != null) {
      await ref.read(followAsyncNotifierProvider.notifier).getFollowings(userId!);
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

            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
  Widget _buildBottomSheet(BuildContext context) {
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
