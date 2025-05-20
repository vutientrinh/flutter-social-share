import 'package:flutter/material.dart';
import 'package:flutter_social_share/utils/uidata.dart';

class UserAvatar extends StatefulWidget {
  final String userName;
  final String avatarUrl;

  const UserAvatar(
      {super.key, required this.userName, required this.avatarUrl});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage:
               NetworkImage(LINK_IMAGE.publicImage(widget.avatarUrl))
        ),

        const SizedBox(width: 12),
        // Name & Subtitle
        Expanded(
          child: Text(
            widget.userName,
            style:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
