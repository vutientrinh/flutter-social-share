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
    _scrollController.addListener(() async {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll - currentScroll <= 300 && !_isFetchingMore) {
        _isFetchingMore = true;
        await ref
            .read(postAsyncNotifierProvider.notifier)
            .fetchNextPage(user!.id);
        _isFetchingMore = false;
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
        backgroundColor: Colors.white,
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
                    Stack(
                      children: [
                        Ink.image(
                          image:
                              NetworkImage(LINK_IMAGE.publicImage(user!.cover)),
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.black
                              .withOpacity(0.3), // Add 30% black overlay
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 70,
                      left: 16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
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
                              const SizedBox(height: 4),
                              Text(
                                'Your order',
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
                // SizedBox(
                //   height: 500, // or MediaQuery height if dynamic
                //   child: TabBarView(
                //     children: [
                //
                //       orderAsyncValue.when(
                //         data: (orders) => ListView.builder(
                //           shrinkWrap: true,
                //           physics: const NeverScrollableScrollPhysics(),
                //           itemCount: orders.length,
                //           itemBuilder: (context, index) =>
                //               Text(orders[index].id),
                //         ),
                //         loading: () =>
                //             const Center(child: CircularProgressIndicator()),
                //         error: (e, st) => Center(child: Text('Error: $e')),
                //       ), // Replace with real orders widget
                //     ],
                //   ),
                // ),
              ],
            ),
    );
  }
}
