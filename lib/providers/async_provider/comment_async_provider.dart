import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/comment.dart';
import 'package:flutter_social_share/model/user.dart';

import '../state_provider/comment_provider.dart';

final commentAsyncNotifierProvider =
AsyncNotifierProvider<CommentNotifier, List<Comment>>(CommentNotifier.new);

class CommentNotifier extends AsyncNotifier<List<Comment>> {
  String? _currentPostId;
  @override
  Future<List<Comment>> build() async {
    return []; // Nothing is fetched automatically
  }

  Future<void> getCommentAPI(String postId) async {
    _currentPostId = postId;
    state = const AsyncLoading();
    final commentService = ref.watch(commentServiceProvider);
    final comments = await commentService.getCommentsAPI(postId);
    if (_currentPostId == postId) {
      state = AsyncData(comments);
    }// ✅ update UI
  }

  Future<void> createComment(String postId, String content) async {
    final commentService = ref.watch(commentServiceProvider);

    // Create the comment
    await commentService.createComment(postId, content);

    // Fetch updated list of comments
    final comments = await commentService.getCommentsAPI(postId);
    state = AsyncData(comments); // ✅ update UI
  }
}
