import 'package:flutter/material.dart';
import 'package:flutter_social_share/model/user.dart';

class HorizontalUserList extends StatelessWidget {
  final List<User> users;

  const HorizontalUserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Text(
                    user.username.isNotEmpty ? user.username[0].toUpperCase() : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user.username,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
