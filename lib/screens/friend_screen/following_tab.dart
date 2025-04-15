import 'package:flutter/material.dart';
import '../../model/user.dart';
import 'list_user.dart';

class FollowingTab extends StatefulWidget {
  const FollowingTab({super.key});

  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<FollowingTab> {
  late Future<List<User>> getFollowing;
  String? userId;

  @override
  void initState() {
    super.initState();
    // getFollowing = loadData();
  }

  // Future<List<User>> loadData() async {
  //   final data = await AuthService.getSavedData();
  //
  //   final userId = data['userId'];
  //   // return FollowService().getFollowings(userId);
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: getFollowing,
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
              final following = snapshot.data![index];
              return ListUser(
                  username: following.username, avatar: following.avatar);
            },
          );
        }
      },
    );
  }
}
