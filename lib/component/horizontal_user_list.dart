import 'package:flutter/material.dart';
import 'package:flutter_social_share/model/user.dart';

import '../screens/messages_screen/chat_detail.dart';

class HorizontalUserList extends StatefulWidget {
  final List<User> users;


  const HorizontalUserList({super.key, required this.users});

  @override
  State<HorizontalUserList> createState() => _HorizontalUserListState();
}

class _HorizontalUserListState extends State<HorizontalUserList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          final user = widget.users[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetail(
                    receiverId: user.id,
                    receiverUsername: user.username,
                  ),
                ),
              );
            },
            child: Container(
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
            ),
          );
        },
      ),
    );
  }
}
