import 'package:flutter/material.dart';

import '../posts/blocs/list_posts_rxdart_bloc.dart';
import '../posts/models/post.dart';
import '../posts/widgets/post_item_remake.dart';

class ProfileScreen extends StatefulWidget {
  final String followerName;
  const ProfileScreen({super.key, required this.followerName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _postsBloc = ListPostsRxDartBloc();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _postsBloc.getPosts();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Ink.image(
                    image: const NetworkImage(
                        'https://wallup.net/wp-content/uploads/2016/02/18/286966-nature-photography.jpg'),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    // Moves the column down
                    child: Column(
                      children: [
                        const CircleAvatar(
                            radius: 50,
                            foregroundImage: NetworkImage(
                                "https://th.bing.com/th/id/OIP.G-H-NFz2OoXJ2GkK74dX4wHaH_?rs=1&pid=ImgDetMain")),
                        Text(
                          widget.followerName,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          '@vutientrinh',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bio:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  'Passionate about coding, design, and technology.'),
                              SizedBox(height: 10),
                              Text('Followers: 1.2K   Following: 200'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostsTab(),
                  _buildProductsTab(),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return StreamBuilder<List<Post>?>(
      stream: _postsBloc.postsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        return ListView(
          children:
              snapshot.data?.map((post) => PostItem(post: post)).toList() ?? [],
        );
      },
    );
  }

  // Products Tab
  Widget _buildProductsTab() {
    final products = [
      {'name': 'iPhone 13 Pro', 'price': '\$999'},
      {'name': 'MacBook Air M2', 'price': '\$1199'},
      {'name': 'Gaming Chair', 'price': '\$250'},
    ];

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: const Icon(Icons.shopping_bag, color: Colors.blueAccent),
          title: Text(product['name']!),
          subtitle: Text(product['price']!),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Clicked on ${product['name']}")),
            );
          },
        );
      },
    );
  }
}
