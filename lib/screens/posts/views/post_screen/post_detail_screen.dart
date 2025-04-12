import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/comment/widgets/list_comment.dart';
import 'package:flutter_social_share/screens/posts/models/post.dart';
import 'package:flutter_social_share/screens/posts/widgets/action_post.dart';
import 'package:flutter_social_share/screens/posts/widgets/grid_image.dart';
import 'package:flutter_social_share/screens/posts/widgets/item_row.dart';

import '../../../../model/post.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post get post => widget.post;

  @override
  Widget build(BuildContext context) {
    print('Post image ne $post.images');
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
                        avatarUrl: post.author.avatar,
                        title: post.author.username,
                        subtitle: post.createdAt,
                        rightWidget: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ),
                    ),
                    GridImage(photos: post.images, padding: 10),
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
