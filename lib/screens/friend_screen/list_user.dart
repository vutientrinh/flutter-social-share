import 'package:flutter/cupertino.dart';
import 'package:flutter_social_share/screens/friend_screen/user_avatar.dart';

class ListUser extends StatefulWidget {
  final String? username;
  final String? avatar;

  const ListUser({super.key, required this.username, required this.avatar});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        // Optional padding between items
        child: UserAvatar(
          userName: widget.username ?? "",
          avatarUrl: widget.avatar ??
              "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
        ));
  }
}
