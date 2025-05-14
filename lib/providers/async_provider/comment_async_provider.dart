import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/model/social/comment.dart';
import '../state_provider/comment_provider.dart';

final commentAsyncNotifierProvider =
    AsyncNotifierProvider<CommentNotifier, List<Comment>>(CommentNotifier.new);

class CommentNotifier extends AsyncNotifier<List<Comment>> {
  @override
  Future<List<Comment>> build() async {
    return []; // Nothing is fetched automatically
  }

  Future<void> getCommentAPI(String postId) async {
    final commentService = ref.watch(commentServiceProvider);
    final comments = await commentService.getCommentsAPI(postId);
    state = AsyncData(comments);
  }

  Future<void> createComment(String postId, String content) async {
    final commentService = ref.watch(commentServiceProvider);
    await commentService.createComment(postId, content);
    final comments = await commentService.getCommentsAPI(postId);
    state = AsyncData(comments);
  }

  Future<void> updateComment(
      String commentId, String content, String postId) async {
    final commentService = ref.watch(commentServiceProvider);
    await commentService.updateComment(commentId, content);
    final comments = await commentService.getCommentsAPI(postId);
    state = AsyncData(comments);
  }

  Future<void> deleteComment(String commentId, String postId) async {
    final commentService = ref.watch(commentServiceProvider);
    await commentService.deleteComment(commentId);
    final comments = await commentService.getCommentsAPI(postId);
    state = AsyncData(comments);
  }
}
