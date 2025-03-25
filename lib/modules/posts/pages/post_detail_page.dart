import 'package:flutter/material.dart';
import 'package:flutter_social_share/modules/comment/widgets/list_comment.dart';
import 'package:flutter_social_share/modules/posts/models/post.dart';
import 'package:flutter_social_share/modules/posts/widgets/action_post.dart';
import 'package:flutter_social_share/modules/posts/widgets/grid_image.dart';
import 'package:flutter_social_share/modules/posts/widgets/item_row.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post get post => widget.post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                title: const Text(
                  'Post Detail Page',
                  style: TextStyle(color: Colors.black),
                ),
                snap: true,
                floating: true,
                elevation: 1,
                forceElevated: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 0, 8),
                      child: ItemRow(
                        avatarUrl: post.urlUserAvatar,
                        title: post.displayName,
                        subtitle: post.displayTimePostCreated,
                        rightWidget: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ),
                    ),
                    if (post.photos != null)
                      GridImage(photos: post.photos!, padding: 0),
                    ActionPost(post: post),
                    const Divider(thickness: 1),
                    ListComment(
                      postId: post.id!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
