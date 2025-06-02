import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/comment_provider.dart';
import 'package:flutter_social_share/screens/comment/widgets/list_comment.dart';
import 'package:flutter_social_share/screens/posts/views/comment_input.dart';
import 'package:flutter_social_share/screens/posts/widgets/action_post.dart';
import 'package:flutter_social_share/screens/posts/widgets/grid_image.dart';
import 'package:flutter_social_share/screens/posts/widgets/item_row.dart';

import '../../../model/social/post.dart';
import '../../../providers/async_provider/comment_async_provider.dart';
import '../../../providers/async_provider/post_async_provider.dart';
import '../../../utils/uidata.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final Post post;
  final String authorId;

  const PostDetailScreen({
    Key? key,
    required this.post,
    required this.authorId,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  Post get post => widget.post;
  bool _isCommentInputVisible = false;

  @override
  void initState() {
    super.initState();
  }

  String? _replyContent;
  String? _replyCommentId;

  void _toggleEditInput(String content, String commentId) {
    if (!mounted) return;
    setState(() {
      _isCommentInputVisible = true;
      _replyContent = content;
      _replyCommentId = commentId;
    });
  }

  void _toggleCommentInput() {
    setState(() {
      _isCommentInputVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                title: const Text(
                  'Post Detail Page',
                  style: TextStyle(color: Colors.black),
                ),
                snap: true,
                floating: true,
                elevation: 1,
                forceElevated: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 0, 8),
                      child: ItemRow(
                        avatarUrl: LINK_IMAGE.publicImage(post.author.avatar),
                        title: post.author.username,
                        subtitle: post.createdAt,
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
                            : PopupMenuButton<String>(
                                onSelected: (String value) async {
                                  switch (value) {
                                    case 'save':
                                      await ref
                                          .read(postAsyncNotifierProvider
                                              .notifier)
                                          .savePost(
                                              widget.authorId, widget.post.id);
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
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          GridImage(photos: post.images, padding: 10),
                          ActionPost(
                            post: post,
                            onCommentButtonPressed: _toggleCommentInput,
                          ),
                          const Divider(thickness: 1),
                          ListComment(
                            post: post,
                            onCommentButtonPressed: _toggleEditInput,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: _isCommentInputVisible
          ? CommentInput(
              post: widget.post,
              content: _replyContent,
              commentId: _replyCommentId,
            )
          : null,
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
