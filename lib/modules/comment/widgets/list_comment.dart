import 'package:flutter/material.dart';
import 'package:flutter_social_share/modules/comment/blocs/list_comment_bloc.dart';
import 'package:flutter_social_share/modules/comment/models/comment.dart';
import 'package:flutter_social_share/modules/comment/repos/list_comments_repo.dart';
import 'package:flutter_social_share/modules/comment/widgets/cmt_item_buble.dart';

class ListComment extends StatefulWidget {
  final String postId;

  const ListComment({Key? key, required this.postId}) : super(key: key);

  @override
  _ListCommentState createState() => _ListCommentState();
}

class _ListCommentState extends State<ListComment> {
  late final ListCommentsBloc commentBloc;

  @override
  void initState() {
    super.initState();
    commentBloc = ListCommentsBloc(ListCommentsRepo(widget.postId))
      ..getComments();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>?>(
      stream: commentBloc.listCmtStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(top: 12),
              child: const Center(
                child: Text('No comment'),
              ),
            );
          }

          return ListView.builder(
            // controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              final comment = snapshot.data![index];

              return Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: CommentItemBubble(
                        cmt: comment,
                        onReact: (type, isUnReact) {
                          // if(!isUnReact){
                          //   commentBloc!.react(comment.id!, type);
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: snapshot.data?.length ?? 0,
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        return const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
