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

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User? user;
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  Future<void> loadData() async {
    final response =
    await ref.read(userServiceProvider).getProfileById(widget.userId);
    setState(() {
      user = response;
    });

    if (user != null) {
      // Now you can safely call getAllOrders
      ref.read(orderAsyncNotifierProvider.notifier).getAllOrders(user!.id);
    }

  }

  @override
  void initState() {
    super.initState();
    loadData();

    _scrollController.addListener(() async {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll - currentScroll <= 300) {
        if (!_isFetchingMore) {
          _isFetchingMore = true;
          await ref.read(postAsyncNotifierProvider.notifier).fetchNextPage();
          _isFetchingMore = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postAsyncValue = ref.watch(postAsyncNotifierProvider);

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
          // Header
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
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bio: ${user!.bio ?? ""}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

                // Tab bar
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.blueAccent,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blueAccent,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Products'),
                  ],
                ),
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPostsTab(),
                      _buildProductsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPostsTab() {
    final postAsyncValue = ref.watch(postAsyncNotifierProvider);

    return postAsyncValue.when(
      data: (posts) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostItem(post: posts[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildProductsTab() {
    final orderAsyncValue = ref.read(orderAsyncNotifierProvider);
    print("Order ne : $orderAsyncValue");
    return orderAsyncValue.when(
      data: (orders) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.blueAccent),
              title: Text(order.orderCode),
              subtitle: Text(order.payment!.amountPaid.toString()),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Clicked on ${order.totalAmount}")),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),

    );
  }
}
