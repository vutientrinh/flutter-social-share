import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/component/create_post.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/screens/posts/widgets/post_item_remake.dart';
import '../../../model/user.dart';
import '../../../providers/async_provider/post_async_provider.dart';
import '../../messages_screen/messages_screen.dart';

class ListPostsScreen extends ConsumerStatefulWidget {
  const ListPostsScreen({Key? key}) : super(key: key);

  @override
  _ListPostsScreenState createState() => _ListPostsScreenState();
}

class _ListPostsScreenState extends ConsumerState<ListPostsScreen> {
  User? author;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUser();
    Future.microtask(() {
      ref.invalidate(postAsyncNotifierProvider);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(postAsyncNotifierProvider.notifier).fetchNextPage();
    }
  }

  Future<void> fetchUser() async {
    final userId = await ref.read(authServiceProvider).getSavedData();
    final user =
        await ref.read(userServiceProvider).getProfileById(userId['userId']);
    setState(() {
      author = user;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postAsyncNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
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
          SliverToBoxAdapter(
            child: author == null
                ? const SizedBox.shrink()
                : CreatePost(
                    avatar: author!.avatar,
                  ),
          ),
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

                if (author == null) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = posts[index];
                      return PostItem(post: post, authorId: author!.id);
                    },
                    childCount: posts.length,
                  ),
                );
              }),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
    );
  }
}
