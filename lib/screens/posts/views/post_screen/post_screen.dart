import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/component/horizontal_user_list.dart';
import 'package:flutter_social_share/providers/post_provider.dart';
import 'package:flutter_social_share/screens/posts/models/post.dart';
import 'package:flutter_social_share/component/create_post.dart';
import 'package:flutter_social_share/screens/posts/views/post_screen/comment_input.dart';
import 'package:flutter_social_share/screens/posts/widgets/post_item_remake.dart';
import 'package:http/http.dart';

import '../../../../model/post.dart';
import '../../../../model/user.dart';
import '../../../../services/user_service.dart';
import '../../../messages_screen/messages_screen.dart';

final postProvider = FutureProvider<List<Post>>((ref) async {
  final postService = ref.watch(postServiceProvider);
  return await postService.getAllPosts();
});
class ListPostsScreen extends ConsumerStatefulWidget {
  const ListPostsScreen({Key? key}) : super(key: key);

  @override
  _ListPostsScreenState createState() => _ListPostsScreenState();
}

class _ListPostsScreenState extends ConsumerState<ListPostsScreen> {
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
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postProvider);
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
          postState.when(
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
