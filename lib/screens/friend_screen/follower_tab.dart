import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/friend_screen/list_user.dart';
import '../../model/user.dart';
import '../../services/auth_service.dart';
import '../../services/follow_service.dart';
import '../../services/friend_service.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  late Future<List<User>> getFollowers;

  @override
  void initState() {
    super.initState();
    getFollowers = loadData();
  }

  Future<List<User>> loadData() async {
    final data = await AuthService.getSavedData();

    final userId = data['userId'];
    return FriendService().getFriends(userId);

    // return FollowService().getFollowers(userId);
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
              final follower = snapshot.data![index];
              return ListUser(
                  username: follower.username, avatar: follower.avatar);
            },
          );
        }
      },
    );
  }
}
