import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/post_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/screens/profile_screen/widget/show_setting_bottom_sheet.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import '../../model/user.dart';
import '../posts/widgets/post_item_remake.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  User? user;
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;
  late TabController _tabController;

  Future<void> loadData() async {
    final response =
        await ref.read(userServiceProvider).getProfileById(widget.userId);
    setState(() {
      user = response;
    });

    if (user != null) {
      ref.read(orderAsyncNotifierProvider.notifier).getAllOrders(user!.id);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(() async {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll - currentScroll <= 300 && !_isFetchingMore) {
        _isFetchingMore = true;
        await ref.read(postAsyncNotifierProvider.notifier).fetchNextPage();
        _isFetchingMore = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postAsyncValue = ref.watch(postAsyncNotifierProvider);
    final orderAsyncValue = ref.watch(orderAsyncNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const ShowSettingBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _scrollController,
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Ink.image(
                      image: NetworkImage(LINK_IMAGE.publicImage(user!.cover)),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      left: 16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 42,
                              backgroundImage: NetworkImage(
                                LINK_IMAGE.publicImage(user!.avatar),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user!.username,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Followers: ${user!.followerCount}   Friends: ${user!.friendsCount}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Orders'),
                  ],
                  labelColor: Colors.blueAccent,
                  unselectedLabelColor: Colors.grey,
                ),
                SizedBox(
                  height: 500, // or MediaQuery height if dynamic
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      postAsyncValue.when(
                        data: (posts) => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (context, index) =>
                              PostItem(post: posts[index]),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, st) => Center(child: Text('Error: $e')),
                      ),
                      orderAsyncValue.when(
                        data: (orders) => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                          itemBuilder: (context, index) =>
                              Text(orders[index].id),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, st) => Center(child: Text('Error: $e')),
                      ), // Replace with real orders widget
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
