import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_share/modules/posts/blocs/list_posts_rxdart_bloc.dart';
import 'package:flutter_social_share/modules/posts/models/post.dart';
import 'package:flutter_social_share/modules/posts/widgets/post_item_remake.dart';

class ListPostsPage extends StatefulWidget {
  const ListPostsPage({Key? key}) : super(key: key);

  @override
  _ListPostsPageState createState() => _ListPostsPageState();
}

class _ListPostsPageState extends State<ListPostsPage> {
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
          const SliverAppBar(
            title: Text(
              'Homefeed',
              style: TextStyle(color: Colors.black),
            ),
            snap: true,
            floating: true,
            elevation: 1,
            forceElevated: true,
            backgroundColor: Colors.white,
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
