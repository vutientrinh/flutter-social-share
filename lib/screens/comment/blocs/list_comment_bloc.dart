import 'package:flutter_social_share/providers/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/comment.dart';
import '../../../services/comment_service.dart';

class ListCommentsBloc extends BlocBase {
  final _commentsCtr = BehaviorSubject<List<Comment>?>();

  Stream<List<Comment>?> get listCmtStream => _commentsCtr.stream;

  List<Comment>? get postsValue => _commentsCtr.value;

  // Future<void> getComment(String postId) async {
  //   try {
  //     final comments = await CommentService().getCommentsAPI(postId);
  //     _commentsCtr.sink.add(comments);
  //   } catch (e) {
  //     print("Error in getComment $e");
  //   }
  // }
  @override
  void dispose() {
    _commentsCtr.close();
  }
}
