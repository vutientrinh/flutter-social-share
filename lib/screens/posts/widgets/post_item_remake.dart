import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/post_async_provider.dart';
import 'package:flutter_social_share/screens/posts/views/post_detail_screen.dart';
import 'package:flutter_social_share/screens/posts/widgets/action_post.dart';
import 'package:flutter_social_share/screens/posts/widgets/grid_image.dart';
import 'package:flutter_social_share/screens/posts/widgets/item_row.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../model/social/post.dart';
import '../../../providers/async_provider/comment_async_provider.dart';
import '../../../utils/uidata.dart';

class PostItem extends ConsumerStatefulWidget {
  final Post post;
  final String authorId;

  const PostItem({Key? key, required this.post, required this.authorId})
      : super(key: key);

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
                      avatarUrl:
                          LINK_IMAGE.publicImage(widget.post.author.avatar),
                      title: widget.post.author.username,
                      subtitle: widget.post.createdAt,
                      rightWidget: widget.authorId == widget.post.author.id
                          ? PopupMenuButton<String>(
                              onSelected: (String value) {
                                switch (value) {
                                  case 'update':
                                    print(
                                        'Update tapped for post: ${widget.post.id}');
                                    break;
                                  case 'delete':
                                    _showDeleteDialog(context);
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'update',
                                  child: Text('Update'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                              icon: const Icon(Icons.more_horiz),
                            )
                          : (widget.post.hasSaved == false
                              ? PopupMenuButton<String>(
                                  onSelected: (String value) async {
                                    switch (value) {
                                      case 'save':
                                        await ref
                                            .read(postAsyncNotifierProvider
                                                .notifier)
                                            .savePost(widget.authorId,
                                                widget.post.id);
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'save',
                                      child: Text('Save'),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_horiz),
                                )
                              : PopupMenuButton<String>(
                                  onSelected: (String value) async {
                                    switch (value) {
                                      case 'Unsave':
                                        print(
                                            'Unsave tapped for post: ${widget.post.id}');
                                        await ref
                                            .read(postAsyncNotifierProvider
                                                .notifier)
                                            .unSavePost(widget.authorId,
                                                widget.post.id);
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Unsave',
                                      child: Text('Unsave'),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_horiz),
                                ))),
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
        builder: (context) =>
            PostDetailScreen(post: widget.post, authorId: widget.authorId),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(postAsyncNotifierProvider.notifier)
                  .deletePost(widget.post.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
