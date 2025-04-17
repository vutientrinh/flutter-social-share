import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/screens/posts/views/post_screen/post_detail_screen.dart';
import 'package:flutter_social_share/screens/posts/widgets/action_post.dart';
import 'package:flutter_social_share/screens/posts/widgets/grid_image.dart';
import 'package:flutter_social_share/screens/posts/widgets/item_row.dart';

import '../../../model/post.dart';
import '../../../providers/async_provider/comment_async_provider.dart';
import '../../../utils/uidata.dart';

class PostItem extends ConsumerStatefulWidget {
  final Post post;

  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  ConsumerState<PostItem> createState() => _PostItemState();
}

class _PostItemState extends ConsumerState<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: () async {
          _navigateToPostDetailPage(context); // then navigate
        },
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
                    avatarUrl:  LINK_IMAGE.publicImage(widget.post.author.avatar?? ""),
                    title: widget.post.author.username,
                    subtitle:widget.post.createdAt,
                    rightWidget: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                    ),
                  ),
                ),
                GridImage(photos: widget.post.images),
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
        builder: (context) => PostDetailScreen(post: widget.post),
      ),
    );
  }
}
