import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/component/horizontal_user_list.dart';
import 'package:flutter_social_share/screens/posts/blocs/list_posts_rxdart_bloc.dart';
import 'package:flutter_social_share/screens/posts/models/post.dart';
import 'package:flutter_social_share/component/create_post.dart';
import 'package:flutter_social_share/screens/posts/views/post_screen/comment_input.dart';
import 'package:flutter_social_share/screens/posts/widgets/post_item_remake.dart';

import '../../../../model/post.dart';
import '../../../../model/user.dart';
import '../../../../services/user_service.dart';
import '../../../messages_screen/messages_screen.dart';

class ListPostsScreen extends ConsumerStatefulWidget {
  const ListPostsScreen({Key? key}) : super(key: key);

  @override
  _ListPostsScreenState createState() => _ListPostsScreenState();
}

class _ListPostsScreenState extends ConsumerState<ListPostsScreen> {
  final _postsBloc = ListPostsRxDartBloc();
  List<User> users = [];
  Future<void> fetchUsers() async {
    // try {
    //   final response = await UserService().getAllUsers(); // Make sure it returns List<String> or List<Map>
    //   setState(() {
    //     users = response; // Adjust if response shape is different
    //   });
    // } catch (e) {
    //   debugPrint("Error fetching users: $e");
    // }
  }

  @override
  void initState() {
    super.initState();
    // _postsBloc.getPosts();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
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
            child: CreatePost(avatar: "",),
          ),
          // CupertinoSliverRefreshControl(
          //   onRefresh: _postsBloc.getPosts,
          // ),
          StreamBuilder<List<Post>?>(
              stream: _postsBloc.postsStream,
              builder: (context, snapshot) {
                print("🔥 Snapshot updated: ${snapshot}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                }

                final posts = snapshot.data;

                if (posts == null || posts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No posts yet')),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final post = posts[index];
                      return PostItem(post: post);
                    },
                    childCount: posts.length,
                  ),
                );
              }
              ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }
}
