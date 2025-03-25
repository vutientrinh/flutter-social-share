import 'package:flutter/material.dart';
import 'package:flutter_social_share/modules/posts/models/post.dart';
import 'package:flutter_social_share/modules/posts/pages/post_detail_page.dart';
import 'package:flutter_social_share/modules/posts/widgets/action_post.dart';
import 'package:flutter_social_share/modules/posts/widgets/grid_image.dart';
import 'package:flutter_social_share/modules/posts/widgets/item_row.dart';

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: () => _navigateToPostDetailPage(context),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 0, 8),
                  child: ItemRow(
                    avatarUrl: widget.post.urlUserAvatar,
                    title: widget.post.displayName,
                    subtitle: widget.post.displayTimePostCreated,
                    rightWidget: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                    ),
                  ),
                ),
                GridImage(photos: widget.post.photos!),
                ActionPost(post: widget.post),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPostDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: widget.post),
      ),
    );
  }
}
