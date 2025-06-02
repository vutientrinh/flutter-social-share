import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/async_provider/order_async_provider.dart';
import 'package:flutter_social_share/providers/async_provider/post_profile_async_provider.dart';
import 'package:flutter_social_share/providers/state_provider/post_provider.dart';
import 'package:flutter_social_share/providers/state_provider/user_provider.dart';
import 'package:flutter_social_share/screens/profile_screen/widget/show_setting_bottom_sheet.dart';
import 'package:flutter_social_share/utils/uidata.dart';
import '../../model/user.dart';
import '../../providers/async_provider/friend_async_provider.dart';
import '../friend_screen/widgets/list_user.dart';
import '../friend_screen/widgets/more_option_bottomsheet.dart';
import '../posts/widgets/post_item_remake.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  User? user;
  final ScrollController _scrollController = ScrollController();
  List<String>? images;
  String _selectedContent = 'Posts'; // Default content type
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? author;

  Future<void> loadData() async {
    final response =
    await ref.read(userServiceProvider).getProfileById(widget.userId);
    final listImages =
    await ref.read(postServiceProvider).getPhotos(widget.userId);
    setState(() {
      user = response;
      images = listImages;
    });

    if (user != null) {
      // Fetch posts for the user using the provider
      await ref
          .read(postProfileAsyncNotifierProvider.notifier)
          .fetchPostsForUser(user!.id);
      ref.read(orderAsyncNotifierProvider.notifier).getAllOrders(user!.id);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(postProfileAsyncNotifierProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  _buildContentSelector(),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildContentSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildSelectorButton('Posts'),
          _buildSelectorButton('Images'),
          _buildSelectorButton('Friends'),
        ],
      ),
    );
  }

  Widget _buildSelectorButton(String contentType) {
    final isSelected = _selectedContent == contentType;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedContent != contentType) {
            setState(() {
              _selectedContent = contentType;
            });
            _animationController.reset();
            _animationController.forward();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              contentType,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedContent) {
      case 'Posts':
        return ref.watch(postProfileAsyncNotifierProvider).when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const Center(child: Text('No posts found.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostItem(
                      post: posts[index],
                      authorId: user!.id,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            );

      case 'Images':
        return images == null
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: images!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: LINK_IMAGE.publicImage(images![index]),
                    fit: BoxFit.cover,
                    // placeholder: (context, url) => const Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  );
                },
              );

      case 'Friends':
        return ref.watch(friendAsyncNotifierProvider).when(
              data: (friends) {
                if (friends.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return ListUser(
                      userId: friend.id,
                      username: friend.username ?? "Unknown",
                      avatar: friend.avatar,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => MoreOptionWidget(
                                  username: friend.username,
                                  avatar: friend.avatar,
                                  followAt: "",
                                  option: "Friend",
                                  id: friend.id,
                                  author: widget.userId,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProfileHeader() {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Stack(
          children: [
            Ink.image(
              image: NetworkImage(LINK_IMAGE.publicImage(user!.cover)),
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.black.withOpacity(0.3),
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
                    'Post: ${user!.postCount}',
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
    );
  }
}
