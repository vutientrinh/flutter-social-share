import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/posts/views/post_screen/create_post_screen.dart';

import '../utils/uidata.dart';

class CreatePost extends StatefulWidget {
  final String avatar;
  const CreatePost({super.key, required this.avatar});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage:  NetworkImage(
              // LINK_IMAGE.publicImage(widget.avatar)
                "https://wallup.net/wp-content/uploads/2016/02/18/286966-nature-photography.jpg"), // replace with your asset or NetworkImage
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  "What do you think?",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
