import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/friend_screen/user_avatar.dart';
import '../../model/user.dart';
import '../../services/auth_service.dart';
import '../../services/follow_service.dart';
import '../profile_screen/profile_screen.dart';

class FollowersTab extends StatefulWidget {
  const FollowersTab({super.key});

  @override
  State<FollowersTab> createState() => _FollowersTabState();
}

class _FollowersTabState extends State<FollowersTab> {
  late Future<List<User>> getFollowers;
  void initState() {
    super.initState();
    getFollowers = loadData();
  }

  Future<List<User>> loadData() async {
    final data = await AuthService.getSavedData();

    final userId = data['userId'];
    return FollowService().getFollowers(userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: getFollowers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Handle error
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.')); // Handle no data
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                // Optional padding between items
                child: UserAvatar(
                  userName: user.username,
                  avatarUrl:
                  "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
                ),
              );
            },
          );
        }
      },
    );
  }
}
