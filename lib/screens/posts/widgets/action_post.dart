import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/post_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/liked_post_provider.dart';
import 'package:flutter_social_share/screens/posts/widgets/text_count_number.dart';

import '../../../model/social/post.dart';

class ActionPost extends ConsumerStatefulWidget {
  final Post post;
  final VoidCallback? onCommentButtonPressed;

  const ActionPost({Key? key, required this.post, this.onCommentButtonPressed})
      : super(key: key);

  @override
  _ActionPostState createState() => _ActionPostState();
}

class _ActionPostState extends ConsumerState<ActionPost> {
  Post get post => widget.post;

  int likeCount = 0;
  bool isLiked = false;

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
  int _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return int.parse(hex, radix: 16);
  }


  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postAsyncNotifierProvider).value;
    final currentPost = posts?.firstWhere((p) => p.id == widget.post.id,
        orElse: () => widget.post);
    final commentCount = currentPost?.commentCount;
    print("Comment count : $commentCount");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(left: 8, top: 8),
                  decoration: BoxDecoration(
                    color: Color(_hexToColor(post.topic.color)),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Text(
                    post.topic.name,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                post.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
                      if (!mounted) return;
                      setState(() {
                        isLiked = !isLiked;
                        likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                        if (isLiked) {
                          likedService.like(post.id);
                        } else {
                          likedService.unlike(post.id);
                        }
                      });
                      if (!mounted) return;
                      ref
                          .read(postAsyncNotifierProvider.notifier)
                          .updatePostLikeStatus(post.id, isLiked, likeCount);
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
                IconButton(
                  icon: const Icon(CupertinoIcons.conversation_bubble),
                  onPressed: widget.onCommentButtonPressed,
                ),
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
                number: commentCount!,
                subText: 'Comment',
              ),
            ],
          ),
        )
      ],
    );
  }

}
