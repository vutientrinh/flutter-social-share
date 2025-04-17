import 'package:flutter/material.dart';
import 'package:flutter_social_share/model/follow_response.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:timeago/timeago.dart' as timeago;

class MoreOptionBottomsheet extends StatefulWidget {
  final String? username;
  final String? avatar;
  final String followAt;
  final String? option;

  const MoreOptionBottomsheet(
      {super.key,
      required this.username,
      required this.avatar,
      required this.followAt,
      required this.option});

  @override
  State<MoreOptionBottomsheet> createState() => _MoreOptionBottomsheetState();
}

class _MoreOptionBottomsheetState extends State<MoreOptionBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: widget.avatar != null
                    ? NetworkImage(LINK_IMAGE.publicImage(widget.avatar ?? ""))
                    : null,
                child: widget.avatar == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.followAt.isNotEmpty)
                    Text(
                      "${widget.option} since ${timeago.format(DateTime.parse(widget.followAt), locale: 'en_short')}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// Message

          _buildListTile(
            icon: Icons.message,
            title: "Message ${widget.username ?? ''}",
            onTap: () => Navigator.pop(context),
          ),

          /// Unfollow
          _buildListTile(
            icon: Icons.person_remove_alt_1,
            title: "Unfollow ${widget.username ?? ''}",
            subtitle: "Stop seeing posts but stay friends",
            onTap: () => Navigator.pop(context),
          ),

          if (widget.option == "Friend")
            _buildListTile(
              icon: Icons.person_off,
              title: "Unfriend ${widget.username ?? ''}",
              subtitle: "Remove ${widget.username ?? 'this user'} as a friend",
              onTap: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
        ),
        child: Icon(icon, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      onTap: onTap,
    );
  }
}
