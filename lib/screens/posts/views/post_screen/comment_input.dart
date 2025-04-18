import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/comment_async_provider.dart';


class CommentInput extends ConsumerStatefulWidget {
  final String postId;
  const CommentInput({super.key, required this.postId});

  @override
  ConsumerState<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  final TextEditingController _commentController = TextEditingController();
  void _sendComment() async {
    final content = _commentController.text.trim();
    if (content.isNotEmpty) {
      print("Send comment: to postId: $widget.postId");
      _commentController.clear();
      FocusScope.of(context).unfocus(); // hide keyboard
      final commentNotifier = ref.read(commentAsyncNotifierProvider.notifier);
      await commentNotifier.createComment(widget.postId, content);
      await commentNotifier.getCommentAPI(widget.postId);
    }
    else{
      FocusScope.of(context).unfocus(); // hide keyboard
    }
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
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
