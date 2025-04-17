import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/comment_async_provider.dart';
import 'package:flutter_social_share/screens/comment/widgets/cmt_item_buble.dart';

class ListComment extends ConsumerStatefulWidget {
  final String postId;

  const ListComment({Key? key, required this.postId}) : super(key: key);

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
          .getCommentAPI(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.read(commentAsyncNotifierProvider);

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
              cmt: comment,
              onReact: (type, isUnReact) {
                // add reaction logic
              },
            );
          },
        );
      },
    );
  }
}
