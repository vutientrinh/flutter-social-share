import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/post.dart';
import 'package:flutter_social_share/providers/async_provider/comment_async_provider.dart';
import 'package:flutter_social_share/screens/comment/widgets/cmt_item_buble.dart';

class ListComment extends ConsumerStatefulWidget {
  final Post post;
  final void Function(String content, String commentId)? onCommentButtonPressed;

  const ListComment({Key? key, required this.post, this.onCommentButtonPressed}) : super(key: key);

  @override
  _ListCommentState createState() => _ListCommentState();
}

class _ListCommentState extends ConsumerState<ListComment> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(commentAsyncNotifierProvider.notifier)
          .getCommentAPI(widget.post.id);
    });

  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentAsyncNotifierProvider);

    return commentState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (comments) {
        if (comments.isEmpty) {
          return const Center(child: Text('No comment'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return CommentItemBubble(
              onCommentButtonPressed: widget.onCommentButtonPressed,
              cmt: comment,
              post: widget.post,
            );
          },
        );
      },
    );
  }
}
