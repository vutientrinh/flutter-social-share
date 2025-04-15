import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/component/horizontal_user_list.dart';
import 'package:flutter_social_share/providers/state_provider/post_provider.dart';
import 'package:flutter_social_share/screens/posts/models/post.dart';
import 'package:flutter_social_share/component/create_post.dart';
import 'package:flutter_social_share/screens/posts/views/post_screen/comment_input.dart';
import 'package:flutter_social_share/screens/posts/widgets/post_item_remake.dart';
import 'package:http/http.dart';

import '../../../../model/post.dart';
import '../../../../model/user.dart';
import '../../../../providers/async_provider/post_async_provider.dart';
import '../../../../services/user_service.dart';
import '../../../messages_screen/messages_screen.dart';


class ListPostsScreen extends ConsumerStatefulWidget {
  const ListPostsScreen({Key? key}) : super(key: key);

  @override
  _ListPostsScreenState createState() => _ListPostsScreenState();
}

class _ListPostsScreenState extends ConsumerState<ListPostsScreen> {
  List<User> users = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postAsyncNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
                    MaterialPageRoute(
                        builder: (context) => const MessagesScreen()),
                  );
                },
              ),
            ],
          ),

          // SliverToBoxAdapter(
          //   child: users.isEmpty
          //       ? const Center(child: CircularProgressIndicator())
          //       : HorizontalUserList(users: users),
          // ),
          const SliverToBoxAdapter(
            child: CreatePost(avatar: "https://wallup.net/wp-content/uploads/2016/02/18/286966-nature-photography.jpg",),
          ),
          // CupertinoSliverRefreshControl(
          //   onRefresh: _postsBloc.getPosts,
          // ),
          postsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
            data: (posts) {
              if (posts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No posts yet')),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final post = posts[index];
                    return PostItem(post: post); // PostItemRemake if you prefer
                  },
                  childCount: posts.length,
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }
}
