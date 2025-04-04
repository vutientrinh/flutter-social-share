import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/screens/posts/blocs/list_posts_rxdart_bloc.dart';
import 'package:flutter_social_share/screens/posts/models/post.dart';
import 'package:flutter_social_share/screens/posts/views/post_screen/create_post.dart';
import 'package:flutter_social_share/screens/posts/widgets/post_item_remake.dart';

import '../../../messages_screen/messages_screen.dart';

class ListPostsScreen extends StatefulWidget {
  const ListPostsScreen({Key? key}) : super(key: key);

  @override
  _ListPostsScreenState createState() => _ListPostsScreenState();
}

class _ListPostsScreenState extends State<ListPostsScreen> {
  final _postsBloc = ListPostsRxDartBloc();

  @override
  void initState() {
    super.initState();
    _postsBloc.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: const Text(
              'Homefeed',
              style: TextStyle(color: Colors.black),
            ),
            snap: true,
            floating: true,
            elevation: 1,
            forceElevated: true,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.wechat_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MessagesScreen()),
                  );
                },
              ),
            ],
          ),
          const SliverToBoxAdapter(
            child: CreatePost(),
          ),

          CupertinoSliverRefreshControl(
            onRefresh: _postsBloc.getPosts,
          ),
          StreamBuilder<List<Post>?>(
              stream: _postsBloc.postsStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return const SliverFillRemaining(
                      child: Center(
                    child: Text('Something went wrong'),
                  ));
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = snapshot.data![index];
                      return PostItem(post: post);
                    },
                    childCount: snapshot.data?.length ?? 0,
                  ),
                );
              }),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }
}
