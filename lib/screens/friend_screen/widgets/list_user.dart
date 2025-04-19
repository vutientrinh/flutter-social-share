import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/route/screen_export.dart';
import 'package:flutter_social_share/screens/friend_screen/widgets/user_avatar.dart';

class ListUser extends StatefulWidget {
  final String? userId;
  final String? username;
  final String? avatar;
  final Widget? trailing;

  const ListUser({
    super.key,
    required this.userId,
    required this.username,
    required this.avatar,
    this.trailing,
  });

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: widget.userId!),
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: UserAvatar(
                userName: widget.username ?? "",
                avatarUrl: widget.avatar ??
                    "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
              ),
            ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}
