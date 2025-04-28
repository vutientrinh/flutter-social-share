import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/post_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/liked_post_provider.dart';
import 'package:flutter_social_share/screens/posts/widgets/icon_post_comment.dart';
import 'package:flutter_social_share/screens/posts/widgets/text_count_number.dart';

import '../../../model/social/post.dart';

class ActionPost extends ConsumerStatefulWidget {
  final Post post;

  const ActionPost({Key? key, required this.post}) : super(key: key);

  @override
  _ActionPostState createState() => _ActionPostState();
}

class _ActionPostState extends ConsumerState<ActionPost> {
  Post get post => widget.post;

  int likeCount = 0;
  bool isLiked = false;

  // int get commentCount => post.commentCounts ?? 0;

  @override
  void initState() {
    super.initState();
    likeCount = post.likedCount ?? 0;
    isLiked = post.hasLiked;
  }

  @override
  void didUpdateWidget(ActionPost oldWidget) {
    super.didUpdateWidget(oldWidget);

    likeCount = widget.post.likedCount ?? 0;
    isLiked = widget.post.hasLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (post.content.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 0, left: 4),
                  child: GestureDetector(
                    onTap: () async {
                      final likedService = ref.read(likedPostServiceProvider);
                      setState(() {
                        isLiked = !isLiked;
                        likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                        if (isLiked) {
                          likedService.like(post.id);

                        } else {
                          likedService.unlike(post.id);
                        }
                      });
                      ref.invalidate(postAsyncNotifierProvider);
                    },
                    child: isLiked
                        ? Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              CupertinoIcons.heart_solid,
                              color: Colors.red,
                            ),
                          )
                        : Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            child: const Icon(CupertinoIcons.heart),
                          ),
                  ),
                ),
                const IconPostComment(),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextCountNumber(
                number: likeCount,
                subText: 'Likes',
              ),
              TextCountNumber(
                number: post.commentCount,
                subText: 'Comment',
              ),
            ],
          ),
        )
      ],
    );
  }
}
