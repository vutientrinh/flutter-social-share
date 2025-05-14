import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_button.dart';
import 'package:flutter_social_share/common/widgets/stateful/react_button/reactive_icon_definition.dart';
import 'package:flutter_social_share/model/user.dart';
import 'package:flutter_social_share/providers/async_provider/comment_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/comment_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import 'package:http/http.dart';

import '../../../model/social/comment.dart';
import '../../../providers/async_provider/post_async_provider.dart';

class CommentItemBubble extends ConsumerStatefulWidget {
  final Comment cmt;
  final Function(int, bool) onReact;

  const CommentItemBubble({
    Key? key,
    required this.cmt,
    required this.onReact,
  }) : super(key: key);

  @override
  ConsumerState<CommentItemBubble> createState() => _CommentItemBubbleState();
}

class _CommentItemBubbleState extends ConsumerState<CommentItemBubble> {
  double sizeAvatar = 32;
  int likeCount = 0;
  bool isLiked = false;
  User? author;
  String? userId;
  @override
  void initState() {
    super.initState();
    likeCount = widget.cmt.likedCount ?? 0;
    isLiked = widget.cmt.hasLiked;
    getAuthor(widget.cmt.authorId);
  }

  @override
  void didUpdateWidget(CommentItemBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    likeCount = widget.cmt.likedCount ?? 0;
    isLiked = widget.cmt.hasLiked;
  }

  void getAuthor(String userId) async {
    final user = await ref.read(authServiceProvider).getSavedData();

    final commentAuthor = await ref.read(userServiceProvider).getProfileById(userId);
    setState(() {
      author = commentAuthor;
      userId = user['userId'];
      print(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: sizeAvatar,
            height: sizeAvatar,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(sizeAvatar / 2),
              child: CachedNetworkImage(
                imageUrl: author != null
                    ? LINK_IMAGE.publicImage(author!.avatar)
                    : "https://th.bing.com/th/id/OIP.YoTUWMoKovQT0gCYOYMwzwHaHa?rs=1&pid=ImgDetMain",
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cmt.author!.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.cmt.content!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, left: 4),
                    child: GestureDetector(
                      onTap: () async {
                        final commentService = ref.read(commentServiceProvider);
                        await commentService.deleteComment(widget.cmt.id);
                        ref.invalidate(commentAsyncNotifierProvider);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          CupertinoIcons.delete,
                          color: Colors.black,
                        ),
                      )
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0, left: 4),
                    child: GestureDetector(
                      onTap: () async {
                        final commentService = ref.read(commentServiceProvider);
                        setState(() {
                          isLiked = !isLiked;
                          likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                          if (isLiked) {
                            commentService.likeComment(widget.cmt.id);
                          } else {
                            commentService.unlikeComment(widget.cmt.id);
                          }
                        });
                      },
                      child: isLiked
                          ? Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                CupertinoIcons.heart_solid,
                                color: Colors.red,
                              ),
                            )
                          : Container(
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(6),
                              child: const Icon(CupertinoIcons.heart),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "$likeCount likes",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
