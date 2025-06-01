import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/comment_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/post_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../model/social/post.dart';
import '../../../providers/async_provider/post_async_provider.dart';

class CommentInput extends ConsumerStatefulWidget {
  final Post post;
  final String? content;
  final String? commentId;

  const CommentInput(
      {super.key, required this.post, this.content, this.commentId});

  @override
  ConsumerState<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });

    if (widget.content != null) {
      _commentController.text = widget.content!;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose(); // Don't forget to dispose this
    super.dispose();
  }

  void _sendComment() async {
    final content = _commentController.text.trim();
    final id = widget.commentId;

    if (content.isEmpty) {
      FocusScope.of(context).unfocus(); // Hide keyboard
      return;
    }

    _commentController.clear();
    FocusScope.of(context).unfocus(); // Hide keyboard
    final commentNotifier = ref.read(commentAsyncNotifierProvider.notifier);
    if (id != null) {
      // Edit existing comment
      await commentNotifier.updateComment(id, content, widget.post.id);
    } else {
      // Create new comment

      await ref
          .read(postAsyncNotifierProvider.notifier)
          .updateComment(widget.post.id, widget.post.commentCount + 1);
      await commentNotifier.createComment(widget.post.id, content);
    }

    await commentNotifier.getCommentAPI(widget.post.id);
    ref.watch(postAsyncNotifierProvider);

    if (mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Write a comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendComment,
            icon: const Icon(Icons.send, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
