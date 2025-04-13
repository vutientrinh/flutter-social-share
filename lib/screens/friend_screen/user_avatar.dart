import 'package:flutter/material.dart';

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
               NetworkImage(widget.avatarUrl)
        ),

        const SizedBox(width: 12),
        // Name & Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
